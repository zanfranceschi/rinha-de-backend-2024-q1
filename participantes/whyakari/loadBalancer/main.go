package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"sync/atomic"
)

type LoadBalancer interface {
	NextServer(req *http.Request) string
}

type RoundRobin struct {
	addrs       []string
	reqCounter  uint64
}

func (rr *RoundRobin) NextServer(req *http.Request) string {
	counter := atomic.AddUint64(&rr.reqCounter, 1)
	return rr.addrs[counter%uint64(len(rr.addrs))]
}

type ProxyHandler struct {
	loadBalancer LoadBalancer
	client       *http.Client
}

func (ph *ProxyHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	targetAddr := ph.loadBalancer.NextServer(r)
	targetURL := &url.URL{
		Scheme: "http",
		Host:   targetAddr,
		Path:   r.URL.Path,
	}
	r.URL = targetURL

	resp, err := ph.client.Do(r)
	if err != nil {
		log.Printf("Error proxying request: %v", err)
		http.Error(w, "Bad Gateway", http.StatusBadGateway)
		return
	}
	defer resp.Body.Close()

	for name, values := range resp.Header {
		w.Header()[name] = values
	}
	w.WriteHeader(resp.StatusCode)

	io.Copy(w, resp.Body)
}

func main() {
	addrs := []string{"api01:3000", "api02:3000"}

	roundRobin := &RoundRobin{addrs: addrs}

	client := &http.Client{}

	http.Handle("/", &ProxyHandler{loadBalancer: roundRobin, client: client})

	port := ":9999"
	fmt.Println("Proxy server listening on port", port)
	if err := http.ListenAndServe(port, nil); err != nil {
		log.Fatal("Error starting proxy server:", err)
	}
}
