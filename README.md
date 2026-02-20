# Case EcoViagens: Inteligência de Dados para Turismo Sustentável 🌿

## 📌 Cenário e Objetivo
A **EcoViagens** é uma plataforma focada em conectar viajantes a experiências de turismo sustentável no Brasil. Como Analista de Dados, meu papel neste projeto foi estruturar o modelo de dados e extrair insights estratégicos para apoiar as áreas de Negócios, Marketing, CRM e Operações.

O foco principal foi transformar dados brutos em inteligência para monitorar o crescimento, entender o comportamento do cliente e garantir o alinhamento com os valores de sustentabilidade da marca.

---

## 🛠️ Etapa 1: Modelagem de Dados
Para suportar as operações, foi desenhado um modelo relacional normalizado que prioriza a integridade referencial.

* **Entidades Principais:** Clientes, Operadores, Ofertas, Reservas e Avaliações.
* **Diferencial de Modelagem (Herança):** Utilizei uma estrutura de herança para as ofertas, permitindo atributos específicos para **Atividades** (nível de dificuldade, duração) e **Hospedagens** (tipo de acomodação, café da manhã).
* **N:N de Sustentabilidade:** Implementei uma tabela associativa (`Oferta_Pratica`) para gerenciar a relação entre experiências e práticas sustentáveis, evitando redundância de dados.

---

## 📈 Etapa 2: Análise SQL e Insights de Negócio
As consultas foram desenvolvidas para responder a perguntas estratégicas da diretoria. Abaixo, os principais pilares analisados:

### 1. Performance Financeira e Pricing
* **Receita Mensal:** Monitoramento do faturamento para identificar sazonalidades.
* **Ticket Médio Individual:** Análise do gasto por pessoa para entender a adesão a opções premium vs. econômicas.

### 2. Fidelização e CRM (Retenção)
* **Taxa de Recompra:** Mensuração da fidelidade da base de clientes.
* **Tempo Médio Entre Reservas:** Utilização de *Window Functions* (`LAG`) para prever o timing ideal de campanhas de reengajamento e evitar churn.

### 3. Sustentabilidade e Qualidade
* **Índice de Adoção:** Percentual de ofertas que realmente possuem práticas sustentáveis implementadas.
* **Análise de Reputação:** Identificação das experiências com melhores avaliações para refinar o portfólio da homepage.

---

## 🚀 Recomendações Estratégicas
* **Fidelização:** Criar programas de recompensas baseados nas experiências melhor avaliadas.
* **Qualidade Operacional:** Estabelecer treinamentos regulares para operadores com desempenho abaixo da média.
* **Posicionamento de Marca:** Intensificar a comunicação das práticas sustentáveis que mais impactam positivamente a satisfação do cliente.

---
*Este projeto faz parte do meu portfólio de análise de dados e demonstra competências em SQL, Modelagem de Dados e Visão de Negócio.*
