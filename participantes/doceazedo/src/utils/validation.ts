import { z } from 'zod';
import { error } from '@sveltejs/kit';

export const validateRequest = async <T>(request: Request, schema: z.ZodType<T>) => {
	let body;
	try {
		body = await request.json();
	} catch (e) {
		return error(422, 'Corpo da requisição deve ser em formato JSON');
	}

	const parsed = await schema.safeParseAsync(body);
	if (!parsed.success) return error(422, parsed as never);
	return parsed.data;
};

export const validateParams = async <T>(
	params: { [key: string]: string },
	schema: z.ZodType<T>
) => {
	const parsed = await schema.safeParseAsync(params);
	if (!parsed.success) return error(422, parsed as never);
	return parsed.data;
};

export const validateId = async (id: string) => {
	const params = await validateParams(
		{ id },
		z.object({
			id: z.coerce.number().int().positive()
		})
	);
	return params.id;
};
