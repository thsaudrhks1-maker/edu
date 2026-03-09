data "external_schema" "sqlalchemy" {
  program = [
    "powershell",
    "-Command",
    "$env:PYTHONPATH='back'; .\\venv\\Scripts\\python.exe back\\atlas_schema.py"
  ]
}

env "local" {
  # .env 파일에서 정보를 읽어오거나 명시적으로 기술합니다.
  url = "postgres://postgres:0000@localhost:5700/postgres?sslmode=disable"
  src = data.external_schema.sqlalchemy.url
  dev = "docker://postgres/15/dev"
  
  format {
    migrate {
      diff = "{{ sql . \"  \" }}"
    }
  }
}
