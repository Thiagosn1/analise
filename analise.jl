using JSON, DataFrames, Dates, PrettyTables

dados_brutos = JSON.parsefile("filmes.json")

dados = DataFrame(dados_brutos)

dados = unique(dados)

filmes_maior_bilheteria = sort(dados, :receita, rev=true)

filmes_ficcao_cientifica = filter(filme -> "Ficção científica" in filme.generos, dados)

filmes_ficcao_cientifica_mais_bem_avaliados = sort(filmes_ficcao_cientifica, :avaliacao_usuarios, rev=true)

filmes_maior_bilheteria = filmes_maior_bilheteria[:, ["titulo", "data_lancamento", "receita", "generos"]]
filmes_ficcao_cientifica_mais_bem_avaliados = filmes_ficcao_cientifica_mais_bem_avaliados[:, ["titulo", "data_lancamento", "avaliacao_usuarios", "generos"]]

println("\nFilmes com maior bilheteria")
pretty_table(first(filmes_maior_bilheteria, 20))

println("\nFilmes de ficção científica mais bem avaliados")
pretty_table(first(filmes_ficcao_cientifica_mais_bem_avaliados, 20))