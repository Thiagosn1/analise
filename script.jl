using HTTP, JSON, DotEnv

# Carrega as variáveis de ambiente do arquivo .env
DotEnv.config()

chave_api = ENV["CHAVE_API"]

# Função para obter os gêneros dos filmes
function obter_generos()
    url = "https://api.themoviedb.org/3/genre/movie/list?api_key=$(chave_api)&language=pt-BR"
    resposta = HTTP.get(url)
    return JSON.parse(String(resposta.body))["genres"]
end

# Função para obter a receita de um filme
function obter_receita(id_filme)
    url = "https://api.themoviedb.org/3/movie/$(id_filme)?api_key=$(chave_api)&language=pt-BR"
    resposta = HTTP.get(url)
    filme = JSON.parse(String(resposta.body))
    return filme["revenue"]
end

# Função para obter o título de um filme em português do Brasil
function obter_titulo(id_filme)
    url = "https://api.themoviedb.org/3/movie/$(id_filme)?api_key=$(chave_api)&language=pt-BR"
    resposta = HTTP.get(url)
    filme = JSON.parse(String(resposta.body))
    return filme["title"]
end

# Função para obter os detalhes dos filmes
function obter_detalhes_filme(numero_pagina, generos)
    url = "https://api.themoviedb.org/3/movie/popular?api_key=$(chave_api)&language=pt-BR&page=$(numero_pagina)"
    resposta = HTTP.get(url)
    filmes = JSON.parse(String(resposta.body))["results"]

    # Extrai apenas os dados necessários de cada filme
    return [Dict(
        "titulo" => obter_titulo(filme["id"]),
        "data_lancamento" => filme["release_date"],
        "receita" => obter_receita(filme["id"]),
        "avaliacao_usuarios" => round(filme["vote_average"], digits=1),
        "generos" => [genero["name"] for genero in generos if genero["id"] in filme["genre_ids"]]
    ) for filme in filmes]
end

generos = obter_generos()
lista_filmes = []
for numero_pagina in 1:100
    println("Preenchendo filmes da página $(numero_pagina)...")
    detalhes_filme = obter_detalhes_filme(numero_pagina, generos)  
    append!(lista_filmes, detalhes_filme)
end

# Função para salvar os dados em um arquivo JSON
function salvar_em_json(dados, nome_arquivo)
    open(nome_arquivo, "w") do f
        write(f, JSON.json(dados, 2))
    end
end

# Salva a lista de filmes em um arquivo JSON
salvar_em_json(lista_filmes, "filmes.json")