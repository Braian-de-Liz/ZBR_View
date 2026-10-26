export type IntegrationId = 'react' | 'vue' | 'fastify' | 'express' | 'nest'

export interface Integration {
  id: IntegrationId
  name: string
  filename: string
  lang: 'tsx' | 'vue' | 'ts'
  label: string
  code: string
}

export const integrations: Integration[] = [
  {
    id: 'react',
    name: 'React Hook Form',
    filename: 'Register.tsx',
    lang: 'tsx',
    label: 'TSX',
    code: `import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { zbr } from 'br_standards_with_zod'
import { z } from 'zod'

const schema = z.object({
  documento: zbr.cpf('CPF inválido'),
  telefone: zbr.tel('Celular inválido')
})

export function Register() {
  const { register, handleSubmit, formState: { errors } } = useForm({
    resolver: zodResolver(schema)
  })

  return (
    <form onSubmit={handleSubmit((data) => console.log(data))}>
      <input {...register('documento')} placeholder="000.000.000-00" />
      {errors.documento && <span>{errors.documento.message}</span>}
      <button>Enviar</button>
    </form>
  )
}`
  },
  {
    id: 'vue',
    name: 'Vue 3',
    filename: 'CepForm.vue',
    lang: 'vue',
    label: 'Vue',
    code: `<script setup lang="ts">
import { ref } from 'vue'
import { z } from 'zod'
import { zbr } from 'br_standards_with_zod'

const schema = z.object({
  cep: zbr.cep('CEP não encontrado')
})

const form = ref({ cep: '' })
const error = ref('')

const validate = () => {
  const result = schema.safeParse(form.value)

  if (!result.success) {
    error.value = result.error.issues[0].message
    return
  }

  error.value = ''
  console.log('Dados limpos:', result.data)
}
</script>

<template>
  <input v-model="form.cep" @blur="validate" placeholder="00000-000" />
  <p v-if="error">{{ error }}</p>
</template>`
  },
  {
    id: 'fastify',
    name: 'Fastify',
    filename: 'server.ts',
    lang: 'ts',
    label: 'TypeScript',
    code: `import Fastify from 'fastify'
import { z } from 'zod'
import { zbr } from 'br_standards_with_zod'

const app = Fastify()

const userSchema = z.object({
  cpf: zbr.cpf('CPF inválido'),
  cep: zbr.cep('CEP inválido')
})

app.post('/user', async (request, reply) => {
  const data = userSchema.parse(request.body)

  return { message: 'Validado!', cleanData: data }
})`
  },
  {
    id: 'express',
    name: 'Express',
    filename: 'routes.ts',
    lang: 'ts',
    label: 'TypeScript',
    code: `import express from 'express'
import { z } from 'zod'
import { zbr } from 'br_standards_with_zod'
import { processRequestBody } from 'zod-express-middleware'

const app = express()

const registrationSchema = z.object({
  body: z.object({
    cnpj: zbr.cnpj('CNPJ inválido'),
    cep: zbr.cep('CEP inválido')
  })
})

app.post(
  '/register',
  processRequestBody(registrationSchema.shape.body),
  (req, res) => {
    res.send({ status: 'Empresa validada' })
  }
)`
  },
  {
    id: 'nest',
    name: 'NestJS',
    filename: 'create-user.dto.ts',
    lang: 'ts',
    label: 'TypeScript',
    code: `import { z } from 'zod'
import { zbr } from 'br_standards_with_zod'

export const CreateUserSchema = z.object({
  nome: z.string().min(3),
  cpf: zbr.cpf('Documento obrigatório'),
  rg: zbr.rg('RG inválido')
})

export type CreateUserDto = z.infer<typeof CreateUserSchema>`
  }
]
