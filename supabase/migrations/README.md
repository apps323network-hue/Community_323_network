# Supabase Migrations

Este diretório contém as migrations SQL do projeto 323 Network.

## Como aplicar migrations

### Opção 1: Via Supabase Dashboard
1. Acesse o Supabase Dashboard
2. Vá em **SQL Editor**
3. Copie o conteúdo do arquivo de migration
4. Execute no SQL Editor

### Opção 2: Via Supabase CLI
```bash
supabase db push
```

### Opção 3: Via MCP (Model Context Protocol)
As migrations podem ser aplicadas usando o Supabase MCP através do assistente.

## Ordem de aplicação

As migrations devem ser aplicadas na ordem numérica:
1. `001_initial_schema.sql` - Schema inicial com todas as tabelas
2. `002_rls_policies.sql` - Row Level Security policies

## Estrutura

- Cada migration é um arquivo SQL numerado sequencialmente
- Nomenclatura: `XXX_description.sql`
- Comentários explicam o propósito de cada migration

## Importante

- **Nunca** modifique uma migration já aplicada
- Crie novas migrations para alterações futuras
- Teste migrations em ambiente de desenvolvimento antes de produção

