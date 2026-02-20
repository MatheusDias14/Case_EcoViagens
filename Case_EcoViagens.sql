-- 1: Receita total mensal
SELECT
  EXTRACT(year FROM r.data_reserva) AS ano,
  format_date('%B', date(r.data_reserva)) AS nome_mes,
  round(sum(o.preco * r.qtd_pessoas), 2) AS receita_total
FROM `caseecoviagens-487620.plataforma.reservas` r
INNER JOIN `caseecoviagens-487620.plataforma.ofertas` o
  ON r.id_oferta = o.id_oferta
WHERE upper(r.status) = 'CONCLUÍDA'
GROUP BY ano, nome_mes, EXTRACT(month FROM r.data_reserva)
ORDER BY ano DESC, EXTRACT(month FROM r.data_reserva);

-- 2: Qual é o valor médio gasto por cliente em cada reserva, considerando o gasto individual por pessoa?

SELECT
  round(sum(o.preco * r.qtd_pessoas) / sum(r.qtd_pessoas), 2) AS media_gasto
FROM `caseecoviagens-487620.plataforma.reservas` r
INNER JOIN `caseecoviagens-487620.plataforma.ofertas` o
  ON r.id_oferta = o.id_oferta
WHERE upper(r.status) = 'CONCLUÍDA';

-- 3: Quais tipos de ofertas são mais populares entre os viajantes?

SELECT
  o.tipo_oferta,
  COUNT(r.id_reserva) AS total_reserva,
  sum(r.qtd_pessoas) AS total_viajantes
FROM `caseecoviagens-487620.plataforma.reservas` r
INNER JOIN `caseecoviagens-487620.plataforma.ofertas` o
  ON r.id_oferta = o.id_oferta
GROUP BY 1;

-- 4: Estamos conseguindo fidelizar nossos clientes ?

SELECT
  round(
    COUNT(*) / (
      SELECT COUNT(DISTINCT id_cliente)
      FROM `caseecoviagens-487620.plataforma.reservas`
      WHERE upper(status) = 'CONCLUÍDA'
    ),
    2)
  * 100 AS porcentagens_fedelizacao
FROM
  (
    SELECT
      id_cliente,
      COUNT(id_reserva) AS contagens
    FROM `caseecoviagens-487620.plataforma.reservas`
    WHERE upper(status) = 'CONCLUÍDA'
    GROUP BY id_cliente
    HAVING COUNT(id_reserva) > 1
  ) clientes_fieis;

-- 5: Quais experiências estão recebendo as melhores avaliações ?

SELECT
  o.id_oferta,
  o.titulo,
  round(avg(a.nota), 2) AS media_nota,
  CASE
    WHEN COUNT(DISTINCT r.id_reserva) = 0 THEN 'Sem reserva conluída'
    WHEN COUNT(DISTINCT r.id_reserva) > 0 AND COUNT(DISTINCT a.id_avaliacao) = 0
      THEN 'Reserva concluída, mas sem avaliação'
    ELSE 'Reserva e avaliação presentes'
    END AS status_oferta
FROM `caseecoviagens-487620.plataforma.ofertas` o
LEFT JOIN `caseecoviagens-487620.plataforma.reservas` r
  ON o.id_oferta = r.id_oferta AND upper(r.status) = 'CONCLUÍDA'
LEFT JOIN `caseecoviagens-487620.plataforma.avaliacoes` a
  ON a.id_oferta = o.id_oferta
GROUP BY 1, 2
ORDER BY media_nota DESC;

-- 6: Quantas ofertas de fato têm práticas sustentáveis implementadas ?

SELECT
  round(
    COUNT(DISTINCT op.id_oferta)
      / (
        SELECT COUNT(DISTINCT id_oferta)
        FROM `caseecoviagens-487620.plataforma.ofertas`
      ),
    2)
  * 100 AS indice_sustentavel_pct
FROM `caseecoviagens-487620.plataforma.oferta_pratica` op;

-- 7: Quais práticas sustentáveis aparecem com mais frequência nas experiências reservadas ?

SELECT
  ps.nome,
  COUNT(r.id_reserva) AS total_reservas,
FROM `caseecoviagens-487620.plataforma.praticas_sustentaveis` ps
JOIN `caseecoviagens-487620.plataforma.oferta_pratica` op
  ON ps.id_pratica = op.id_pratica
JOIN `caseecoviagens-487620.plataforma.reservas` r
  ON op.id_oferta = r.id_oferta
GROUP BY ps.nome
ORDER BY total_reservas DESC;

-- 8: Com que frequência os clientes fiéis fazem novas reservas ?

WITH
  reservas_filtradas AS (
    SELECT id_cliente, data_reserva
    FROM `caseecoviagens-487620.plataforma.reservas`
    WHERE
      status = 'concluída'
      AND id_cliente IN (
        SELECT id_cliente
        FROM `caseecoviagens-487620.plataforma.reservas`
        WHERE status = 'concluída'
        GROUP BY id_cliente
        HAVING COUNT(*) > 1
      )
  ),
  diffs AS (
    SELECT
      id_cliente,
      date_diff(
        data_reserva,
        lag(data_reserva) OVER (PARTITION BY id_cliente ORDER BY data_reserva),
        day) AS diff_dias
    FROM reservas_filtradas
  )
SELECT id_cliente, avg(diff_dias) AS tempo_medio_entre_reservas
FROM diffs
WHERE diff_dias IS NOT NULL
GROUP BY id_cliente;

-- 9: Identificar quais operadores se destacam por tipo de experiência ?

WITH
  reservas_concluidas AS (
    SELECT DISTINCT (id_oferta) AS id_oferta
    FROM `caseecoviagens-487620.plataforma.reservas`
    WHERE upper(status) = 'CONCLUÍDA'
  )
SELECT
  op.nome_fantasia,
  o.tipo_oferta,
  round(avg(a.nota), 2) AS media_avaliacao
FROM `caseecoviagens-487620.plataforma.avaliacoes` a
INNER JOIN `caseecoviagens-487620.plataforma.ofertas` o
  ON a.id_oferta = o.id_oferta
INNER JOIN reservas_concluidas rs
  ON rs.id_oferta = o.id_oferta
INNER JOIN `caseecoviagens-487620.plataforma.operadores` op
  ON op.id_operador = o.id_oferta
GROUP BY 1, 2
ORDER BY 2, 3 DESC;
