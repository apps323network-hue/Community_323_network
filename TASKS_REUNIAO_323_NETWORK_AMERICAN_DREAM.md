# 📋 Tasks - Reunião 323 Network & American Dream

## 📊 **RESUMO DE PROGRESSO SSO**

**Última Atualização**: 2026-01-02

### ✅ **Tasks Concluídas:**
- ✅ **SSO-1**: Configurar Supabase Auth Compartilhado (100%)
- ✅ **SSO-2**: Implementar Validação de Token Entre Sistemas (100%)
- ✅ **AD-2**: Manter Dados Separados do 323 Network (100%)

### 🟡 **Tasks Parcialmente Concluídas:**
- 🟡 **SSO-3**: Criar Interface de Login Unificada (90% - falta indicador no American Dream)
- 🟡 **AD-1**: Configurar Autenticação Compartilhada (85% - falta indicador visual)

### ⚠️ **Tasks Pendentes:**
- ⚠️ **SSO-4**: Sincronização de Sessões (0% - não crítica para funcionamento básico)

**Progresso Geral SSO**: 🟢 **~85% Concluído**

---

## 🔐 **AUTENTICAÇÃO COMPARTILHADA (SSO) - PRIORIDADE ALTA**

Estas tasks são fundamentais para permitir que os dois sistemas funcionem de forma integrada.

### **Task SSO-1: Configurar Supabase Auth Compartilhado**
- [x] Analisar estrutura atual de autenticação do 323 Network
- [x] Analisar estrutura atual de autenticação do American Dream
- [x] Decidir estratégia: mesmo projeto Supabase Auth ou projetos separados com JWT compartilhado
- [x] Configurar Supabase Auth para suportar múltiplos projetos/sistemas
- [x] Implementar middleware de autenticação compartilhada
- [x] Testar autenticação cruzada entre sistemas

**Status**: ✅ **CONCLUÍDA**  
**Responsável**: Backend/DevOps  
**Prioridade**: 🔴 CRÍTICA  
**Dependências**: Nenhuma (bloqueia outras tasks)  
**Notas**: JWT Secret compartilhado configurado. Edge Functions criadas para sincronização.

---

### **Task SSO-2: Implementar Validação de Token Entre Sistemas**
- [x] Criar serviço de validação de JWT tokens
- [x] Configurar mesma chave secreta JWT entre projetos (se necessário)
- [x] Implementar endpoint de validação de token
- [x] Criar middleware para verificar tokens de ambos os sistemas
- [x] Adicionar logs de autenticação compartilhada
- [x] Documentar fluxo de autenticação

**Status**: ✅ **CONCLUÍDA**  
**Responsável**: Backend  
**Prioridade**: 🔴 CRÍTICA  
**Dependências**: SSO-1  
**Notas**: Tokens JWT funcionam entre sistemas. Validação via Supabase Auth nativo. Documentação completa em SSO_DOCUMENTACAO_COMPLETA_AMERICAN_DREAM.md

---

### **Task SSO-3: Criar Interface de Login Unificada**
- [x] Criar componente de login que funcione para ambos os sistemas
- [x] Implementar redirecionamento após login baseado em origem
- [ ] Adicionar indicador visual de "Login com 323 Network" no American Dream
- [x] Adicionar indicador visual de "Login com American Dream" no 323 Network (se necessário)
- [x] Testar fluxo de login em ambos os sistemas

**Status**: 🟡 **PARCIALMENTE CONCLUÍDA** (90%)  
**Responsável**: Frontend  
**Prioridade**: 🟡 ALTA  
**Dependências**: SSO-1, SSO-2  
**Notas**: Login.vue detecta `source=american-dream`, pré-preenche formulário, redireciona com token. Badge "American Dream" adicionado na página de login. Falta apenas indicador no lado American Dream.

---

### **Task SSO-4: Sincronização de Sessões**
- [ ] Implementar sincronização de sessões entre sistemas
- [ ] Garantir que logout em um sistema afete o outro (opcional/configurável)
- [ ] Implementar refresh token compartilhado
- [ ] Adicionar timeout de sessão consistente
- [ ] Testar cenários de sessão expirada

**Status**: ⚠️ **PENDENTE**  
**Responsável**: Backend  
**Prioridade**: 🟡 ALTA  
**Dependências**: SSO-1, SSO-2  
**Notas**: Funcionalidade básica de SSO funciona, mas sincronização avançada de sessões ainda não implementada. Não é crítica para funcionamento básico.

---

## 🏢 **323 NETWORK - TASKS**

### **Task 323-1: Criar Seção "Benefícios" no Menu Principal**
- [ ] Adicionar item "Benefícios" no menu de navegação
- [ ] Criar rota `/beneficios` ou `/benefits`
- [ ] Criar componente `BenefitsPage.vue` ou similar
- [ ] Implementar layout de cards para parceiros
- [ ] Integrar com tabela `partners` existente
- [ ] Adicionar filtros por categoria (academias, fotógrafos, contadores, etc.)
- [ ] Exibir descontos exclusivos para membros
- [ ] Adicionar busca de parceiros
- [ ] Implementar design responsivo
- [ ] Adicionar traduções (pt-BR e en-US)

**Responsável**: Frontend  
**Prioridade**: 🟡 ALTA  
**Dependências**: Nenhuma

---

### **Task 323-2: Renomear "Cursos" para "Programas"**
- [ ] Atualizar menu de navegação: "Cursos" → "Programas"
- [ ] Atualizar rotas (se necessário)
- [ ] Atualizar traduções:
  - pt-BR: "Programas"
  - en-US: "Shows" ou "Programs"
- [ ] Atualizar componentes que referenciam "Cursos"
- [ ] Atualizar documentação
- [ ] Verificar e atualizar URLs/links internos

**Responsável**: Frontend  
**Prioridade**: 🟡 ALTA  
**Dependências**: Nenhuma

---

### **Task 323-3: Desenvolver Área de "Programas" com Player de Vídeo**
- [ ] Criar estrutura de dados para programas (tabela `programs`)
  - [ ] id, titulo, descricao, tipo (us_venture_prep, ingles, marketing, etc.)
  - [ ] video_url, anexos (array), professor_id, status
  - [ ] created_at, updated_at
- [ ] Criar interface de listagem de programas
- [ ] Implementar player de vídeo integrado
- [ ] Criar área de anexos (estilo simplificado Google Classroom)
- [ ] Adicionar funcionalidade de download de materiais
- [ ] Implementar design responsivo
- [ ] Adicionar filtros por tipo de programa
- [ ] Adicionar busca de programas

**Responsável**: Full-stack  
**Prioridade**: 🟡 ALTA  
**Dependências**: 323-2

---

### **Task 323-4: Implementar LMS Integrado (Google Classroom Style)**
- [ ] Criar interface para professores postarem conteúdo
- [ ] Implementar área de postagem de matéria
- [ ] Implementar área de postagem de vídeos
- [ ] Implementar área de postagem de avisos
- [ ] Criar sistema de upload de arquivos
- [ ] Adicionar preview de conteúdo antes de publicar
- [ ] Implementar notificações para alunos quando novo conteúdo é postado
- [ ] Adicionar timeline/feed de atividades do programa
- [ ] Implementar design estilo Google Classroom (simplificado)

**Responsável**: Full-stack  
**Prioridade**: 🟡 ALTA  
**Dependências**: 323-3

---

### **Task 323-5: Upload Facilitado para Professores (Múltiplos Canais)**
- [ ] Implementar upload via interface web
- [ ] Criar endpoint para upload via e-mail (webhook)
- [ ] Criar endpoint para upload via SMS (webhook)
- [ ] Criar endpoint para upload via API mobile
- [ ] Implementar processamento automático de anexos recebidos
- [ ] Adicionar validação de formato de arquivo
- [ ] Adicionar limite de tamanho de arquivo
- [ ] Criar notificações quando conteúdo é recebido via e-mail/SMS
- [ ] Documentar como professores podem usar cada canal

**Responsável**: Backend + Integrações  
**Prioridade**: 🟢 MÉDIA  
**Dependências**: 323-4

---

### **Task 323-6: Sistema de Cupons de Patrocínio**
- [ ] Criar tabela `coupons` no banco de dados
  - [ ] id, codigo, descricao, desconto_percentual, desconto_fixo
  - [ ] valor_minimo, data_inicio, data_fim, ativo
  - [ ] limite_uso, usado_por (array de user_ids)
  - [ ] programa_id (opcional - cupom específico para programa)
  - [ ] created_at, updated_at
- [ ] Criar interface admin para gerenciar cupons
- [ ] Adicionar campo de cupom no checkout/pagamento
- [ ] Implementar validação de cupom (código, validade, limite)
- [ ] Integrar com sistema de pagamentos (Stripe)
- [ ] Aplicar desconto no cálculo de pagamento
- [ ] Adicionar histórico de uso de cupons
- [ ] Criar relatórios de cupons utilizados
- [ ] Adicionar notificações quando cupom é aplicado

**Responsável**: Full-stack  
**Prioridade**: 🟡 ALTA  
**Dependências**: 323-3, Sistema de pagamentos existente

---

### **Task 323-7: Migrar Módulo "Etapas de Planejamento" do American Dream**
- [ ] Analisar estrutura atual do American Dream
  - [ ] Identificar tabelas relacionadas a etapas de planejamento
  - [ ] Identificar lógica de negócio
  - [ ] Identificar dependências
- [ ] Criar estrutura de dados na 323 Network
  - [ ] Tabela `planning_stages` ou similar
  - [ ] Tabela `user_planning_progress` ou similar
  - [ ] Migrar relacionamentos necessários
- [ ] Migrar dados existentes (se houver)
- [ ] Adaptar lógica de negócio para 323 Network
- [ ] Criar interface de visualização de etapas
- [ ] Criar interface de acompanhamento de progresso
- [ ] Integrar com dashboard do usuário
- [ ] Testar funcionalidade completa
- [ ] Documentar migração

**Status**: ⚠️ **PENDENTE** (0/15)  
**Responsável**: Full-stack  
**Prioridade**: 🟡 ALTA  
**Dependências**: SSO-1, SSO-2 (✅ ambas concluídas - pode iniciar)  
**Notas**: Dependências concluídas. Task complexa que requer análise detalhada do American Dream.  
**Trello**: ⚠️ 0/15 - Não iniciada

---

### **Task 323-8: Remover Branding Pessoal e Substituir por Marca 323 Network**
- [ ] Identificar todas as fotos dos sócios no sistema
- [ ] Identificar referências pessoais (nomes, biografias, etc.)
- [ ] Substituir por elementos da marca 323 Network
- [ ] Atualizar "Sobre Nós" / "About Us"
- [ ] Atualizar páginas de parceiros
- [ ] Atualizar materiais de marketing
- [ ] Tornar ambiente mais institucional e profissional
- [ ] Manter identidade visual consistente
- [ ] Revisar textos para tom mais corporativo

**Responsável**: Frontend + Design  
**Prioridade**: 🟢 MÉDIA  
**Dependências**: Nenhuma

---

### **Task 323-9: Melhorar Multilíngue Real**
- [ ] Revisar todas as traduções existentes
- [ ] Garantir que "Programas" → "Shows" ou "Programs" em inglês
- [ ] Adicionar traduções faltantes
- [ ] Verificar consistência de termos técnicos
- [ ] Testar mudança de idioma em todas as páginas
- [ ] Garantir que URLs e metadados também sejam traduzidos
- [ ] Adicionar traduções para novos componentes (Benefícios, Programas, etc.)

**Responsável**: Frontend  
**Prioridade**: 🟢 MÉDIA  
**Dependências**: 323-1, 323-2, 323-3

---

### **Task 323-10: Integração com Matrícula US (Link Direto)**
- [ ] Analisar sistema Matrícula US
  - [ ] Identificar tecnologia usada (Supabase, Firebase, custom, etc.)
  - [ ] Verificar se tem API de autenticação disponível
  - [ ] Verificar se suporta OAuth 2.0 / OIDC
  - [ ] Identificar endpoints disponíveis
- [ ] Escolher estratégia de integração (ver opções abaixo)
- [ ] Criar botão/link de integração "Single Sign-On" no 323 Network
- [ ] Implementar solução escolhida
- [ ] Garantir que usuário logado no 323 Network seja reconhecido no Matrícula US
- [ ] Testar fluxo completo de integração
- [ ] Adicionar documentação para usuários

**Status**: ⚠️ **PENDENTE** (0/7)  
**Responsável**: Backend + Integrações  
**Prioridade**: 🟢 MÉDIA  
**Dependências**: SSO-1, SSO-2, SSO-3 (✅ todas concluídas - pode iniciar)  

**⚠️ IMPORTANTE**: Matrícula US tem 200+ alunos ativos e é plataforma estabelecida. **NÃO podemos usar JWT compartilhado** (como fizemos com American Dream) pois quebraria o sistema existente.

**🎯 ESTRATÉGIAS RECOMENDADAS** (escolher uma):

#### **Opção 1: Edge Function de Validação (Recomendada) ⭐**
**Como funciona:**
- Criar Edge Function no 323 Network: `validate-323-network-user`
- Matrícula US chama essa função passando token JWT do 323 Network
- Edge Function valida token e retorna dados do usuário (email, id, etc.)
- Matrícula US cria sessão própria com esses dados

**Vantagens:**
- ✅ Zero mudanças no Matrícula US (só adiciona chamada API)
- ✅ Não quebra sistema existente
- ✅ Seguro (validação server-side)
- ✅ Simples de implementar

**Implementação:**
```typescript
// Edge Function no 323 Network
// Matrícula US chama: POST /functions/v1/validate-323-network-user
// Headers: { Authorization: "Bearer <token_323_network>" }
// Retorna: { valid: true, user: { id, email, name } }
```

#### **Opção 2: OAuth 2.0 / OIDC (Se Matrícula US suportar)**
**Como funciona:**
- 323 Network atua como OAuth Provider
- Matrícula US atua como OAuth Client
- Fluxo OAuth padrão da indústria

**Vantagens:**
- ✅ Padrão da indústria
- ✅ Muito seguro
- ✅ Escalável

**Desvantagens:**
- ⚠️ Requer que Matrícula US suporte OAuth
- ⚠️ Mais complexo de implementar

#### **Opção 3: Magic Link / Token Temporário**
**Como funciona:**
- 323 Network gera token temporário único (válido por 5-10 minutos)
- Redireciona para Matrícula US com token na URL
- Matrícula US valida token via API do 323 Network
- Cria sessão própria

**Vantagens:**
- ✅ Simples de implementar
- ✅ Token temporário (mais seguro)
- ✅ Não requer mudanças grandes

**Trello**: ⚠️ 0/7 - Não iniciada

---

## 🇺🇸 **AMERICAN DREAM - TASKS**

### **Task AD-1: Configurar Autenticação Compartilhada (Lado American Dream)**
- [x] Integrar com sistema de autenticação compartilhada
- [x] Configurar validação de tokens do 323 Network
- [x] Implementar middleware de autenticação
- [x] Criar interface de login que aceita credenciais do 323 Network
- [ ] Adicionar indicador visual "Login com 323 Network"
- [x] Testar autenticação cruzada
- [x] Garantir que dados do American Dream permaneçam no banco próprio

**Status**: 🟡 **PARCIALMENTE CONCLUÍDA** (6/7 - 85%)  
**Responsável**: Backend + Frontend  
**Prioridade**: 🔴 CRÍTICA  
**Dependências**: SSO-1, SSO-2  
**Notas**: JWT Secret compartilhado configurado. Edge Function `sync-user-to-american-dream` cria usuários automaticamente. Falta apenas indicador visual no American Dream (task do lado American Dream).  
**Trello**: ✅ 7/7 marcado (mas falta implementar indicador visual no código do American Dream)

---

### **Task AD-2: Manter Dados Separados do 323 Network**
- [x] Garantir que banco de dados do American Dream seja independente
- [x] Verificar que dados de mentoria não sejam compartilhados
- [x] Verificar que dados de mentees não sejam compartilhados
- [x] Manter apenas autenticação compartilhada
- [x] Adicionar validações para garantir isolamento de dados
- [x] Documentar estrutura de dados do American Dream

**Status**: ✅ **CONCLUÍDA** (6/6)  
**Responsável**: Backend  
**Prioridade**: 🔴 CRÍTICA  
**Dependências**: SSO-1, SSO-2  
**Notas**: Dados permanecem em bancos separados. Apenas autenticação compartilhada. Documentado em SSO_DOCUMENTACAO_COMPLETA_AMERICAN_DREAM.md  
**Trello**: ✅ 6/6 concluído

---

### **Task AD-3: Atualizar Interface para Refletir Integração**
- [ ] Adicionar logo/link para 323 Network
- [ ] Atualizar textos para mencionar integração (se necessário)
- [ ] Garantir que identidade visual seja consistente mas distinta
- [ ] Adicionar navegação entre sistemas (se necessário)
- [ ] Testar experiência do usuário entre sistemas

**Status**: ⚠️ **PENDENTE** (0/5)  
**Responsável**: Frontend  
**Prioridade**: 🟢 MÉDIA  
**Dependências**: AD-1 (🟡 85% concluída - pode iniciar parcialmente)  
**Notas**: Task do lado American Dream. Pode ser iniciada após AD-1 estar completa.  
**Trello**: ⚠️ 0/5 - Não iniciada

---

## 📊 **RESUMO DE PRIORIDADES**

### 🔴 **CRÍTICAS (Fazer Primeiro)**
1. SSO-1: Configurar Supabase Auth Compartilhado
2. SSO-2: Implementar Validação de Token Entre Sistemas
3. AD-1: Configurar Autenticação Compartilhada (Lado American Dream)
4. AD-2: Manter Dados Separados do 323 Network

### 🟡 **ALTAS (Fazer em Seguida)**
1. SSO-3: Criar Interface de Login Unificada
2. SSO-4: Sincronização de Sessões
3. 323-1: Criar Seção "Benefícios"
4. 323-2: Renomear "Cursos" para "Programas"
5. 323-3: Desenvolver Área de "Programas"
6. 323-4: Implementar LMS Integrado
7. 323-6: Sistema de Cupons
8. 323-7: Migrar Módulo "Etapas de Planejamento"

### 🟢 **MÉDIAS (Fazer Depois)**
1. 323-5: Upload Facilitado para Professores
2. 323-8: Remover Branding Pessoal
3. 323-9: Melhorar Multilíngue Real
4. 323-10: Integração com Matrícula US
5. AD-3: Atualizar Interface para Refletir Integração

---

## 🔗 **DEPENDÊNCIAS ENTRE TASKS**

```
SSO-1 (Auth Compartilhado)
  ├── SSO-2 (Validação de Token)
  │   ├── SSO-3 (Interface Login)
  │   ├── SSO-4 (Sincronização Sessões)
  │   ├── AD-1 (Auth American Dream)
  │   ├── AD-2 (Dados Separados)
  │   ├── 323-7 (Migrar Etapas)
  │   └── 323-10 (Matrícula US)
  │
  └── 323-2 (Renomear Cursos)
      └── 323-3 (Área Programas)
          ├── 323-4 (LMS Integrado)
          │   └── 323-5 (Upload Múltiplos Canais)
          │
          └── 323-6 (Sistema Cupons)

323-1 (Benefícios) [Independente]
323-8 (Remover Branding) [Independente]
323-9 (Multilíngue) [Depende de 323-1, 323-2, 323-3]
AD-3 (Interface AD) [Depende de AD-1]
```

---

## 📝 **NOTAS IMPORTANTES**

1. **Autenticação é a Base**: Todas as tasks de integração dependem do SSO funcionando
2. **Dados Separados**: Garantir que apenas autenticação seja compartilhada, dados permanecem separados
3. **Priorizar SSO**: Tasks de autenticação devem ser feitas primeiro
4. **Testes Cruzados**: Sempre testar funcionalidades que envolvem ambos os sistemas
5. **Documentação**: Documentar todas as integrações e decisões técnicas

---

**Status**: ✅ Tasks organizadas e priorizadas  
**Última Atualização**: 2026-01-02  
**Progresso SSO**: 
- ✅ SSO-1: CONCLUÍDA
- ✅ SSO-2: CONCLUÍDA  
- 🟡 SSO-3: 90% (falta indicador no American Dream)
- ⚠️ SSO-4: PENDENTE (não crítica)
- 🟡 AD-1: 85% (falta indicador visual)
- ✅ AD-2: CONCLUÍDA

**Próxima Ação**: 
1. ✅ **SSO Básico Funcionando** - Tasks críticas concluídas
2. 🟡 **AD-1**: Adicionar indicador visual "Login com 323 Network" no American Dream (1 item pendente)
3. ⚠️ **323-10**: Iniciar integração com Matrícula US (dependências OK)
4. ⚠️ **323-7**: Iniciar migração de Etapas de Planejamento (dependências OK)
5. ⚠️ **AD-3**: Atualizar interface American Dream (aguardar AD-1 completa)

**Status Trello vs Documento**:
- ✅ **SSO Geral**: 19/19 no Trello = ✅ CONCLUÍDA
- 🟡 **AD-1**: 7/7 no Trello, mas falta 1 item no código (indicador visual)
- ✅ **AD-2**: 0/6 no Trello, mas ✅ 6/6 CONCLUÍDA no código (atualizar Trello)
- ⚠️ **323-10**: 0/6 - PENDENTE (pode iniciar)
- ⚠️ **AD-3**: 0/5 - PENDENTE (aguardar AD-1)
- ⚠️ **323-7**: 0/15 - PENDENTE (pode iniciar)

