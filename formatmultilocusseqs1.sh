# Esse código é composto por várias ETAPAS.

# INFORMAÇÕES IMPORTANTES:
# Os arquivos originais devem estar em .faa
# Para executar esse código, o CABEÇALHO de cada sequencia deve seguir esse padrão:
# ">espécie.linhagem_IDdoPROKKA nome da sequencia"
# Por exemplo: ">P_atlantica.3155_06618 hypothetical protein"
# Por exemplo: ">P_kururiensis.KP23_06502 Surface presentation of antigens protein SpaQ"
# Por exemplo: ">P_tropica.22274_00490 Secretion system apparatus protein SsaV"
# Por exemplo: ">P_sacchari.19450_00327 Yop proteins translocation protein U"
# Por exemplo: ">P_caribensis.88_06867 putative ATP synthase YscN"

# ETAPA 1:
# Limpa tudo que vem após o ESPAÇO nos cabeçalhos e resulta em arquivos ".fa1"
for file in *.faa; do
    sed -E 's/^(>[^[:space:]]+[._][0-9]+).*/\1/' "$file" > "${file%.faa}.fa1"
done

# ETAPA 2:
# Limpa o restante dos cabeçalhos após o último "_" e resulta em arquivos ".fa2"
for file in *.fa1; do
    sed -E 's/^(>[A-Za-z0-9_]+\.[A-Za-z0-9]+).*/\1/' "$file" > "${file%.fa1}.fa2"
done

# ETAPA 3:
# Agora vamos limpar e organizar os arquivos dentro do diretório, mantendo os resultados finais .faa e os originais com uma tag final de "_original._faa"
rename 's/.faa$/_original._faa/' *.faa
rename 's/.fa2$/.faa/' *.fa2
rm *.fa1

# ETAPA 4:
# Agora vamos padronizar os cabeçalhos para a leitura do código de concatenação
for file in *.faa; do
    # Cria um novo arquivo temporário para armazenar as modificações
    # sed 's/^>\(.*\)[_.]\(.*\)/>\1\2/' "$file" > temp.faa
    sed 's/^>.*$/\L&/; s/[_.]//g' "$file" > temp.faa
    # Substitui o arquivo original pelo arquivo temporário
    mv temp.faa "$file"
    echo "Processado: $file"
done

# Concluímos por aqui, verifique se seus arquivos estão corretos.

# Caso não queira manter os originais por já ter um backup, retire o "#" do início da sentença abaixo:
#rm *_original._faa

# Esse comando foi inicialmente utilizado para uma análise MLSA do T3SS (31/10/2024).
# Caso utilize para outra análise MLSA, pontuar aqui embaixo.












