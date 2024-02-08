import { json } from '@sveltejs/kit';

export const GET = () => {
	return json({
		greetings: 'Hello Rinha de Backend 2024/Q1 from SvelteKit 2!',
		author: {
			name: 'Doce',
			url: 'https://doceazedo.com'
		},
		date: new Date().toISOString()
	});
};
