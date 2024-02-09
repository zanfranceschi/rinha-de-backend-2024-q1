package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
)

func init() {
	connectDB()
}

type transaction struct {
	Valor     int
	Tipo      string
	Descricao string
}

func main() {
	port := fmt.Sprintf(":%s", os.Getenv("PORT"))
	r := chi.NewRouter()
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("alive"))
	})

	r.Post("/clientes/{id}/transacoes", handleTrasactions)

	http.ListenAndServe(port, r)

}

func handleTrasactions(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")

	var t transaction

	err := json.NewDecoder(r.Body).Decode(&t)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(id)
	fmt.Println(t)
	w.Write([]byte("alive"))

}
