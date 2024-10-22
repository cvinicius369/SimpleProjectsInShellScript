# So pra ficar bonitin
banner(){
    echo "-----------------------------------"
    echo "   N E T W O R K - S C A N N E R   "
    echo "-----------------------------------"
}
# separa a funcao que gera o relatorio de scaneamento de rede
# futuramente implementarei outras funcoes nesse codigo
geraRelatorio(){
    echo "Relatorio de Rede - $(date)" > "$1"
    echo "-----------------------------------" > "$1"
    echo "" > "$1"

    echo "Iniciando scanner na faixa $2 . . ."
    nmap -sn "$rede" > tmp_ips.txt

    echo "Dispositivos ativos na rede: " >> "$1"
    grep "Nmap scan report for " tmp_ips.txt | awk '{print $5}' >> "$1"
    echo "" >> "$1"

    echo "Escaneando portas abertas dos dispositivos encontrados . . ."
    echo "Portas abertas por dispositivo: " >> "$1"

    while IFS= read -r IP; do
        echo "Escaneando $IP . . ."
        echo "Relatorio de portas abertas para $IP: " >> "$1"
        nmap -p- "$IP" | grep "open" >> "$1"
        echo "" >> "$1"
    done < <(grep "Nmap scan report for" tmp_ips.txt | awk '{print 5}')

    rm tmp_ips.txt # deletando dados temporarios
}
# a classica funcao main
main(){
    banner
    read -p "Digite o ip da rede: " rede
    relatorio="Relatorio_Rede$(date +%F_%T).txt"
    echo "Lembrando que voce precisa ter o nmap em sua maquina ;)"
    geraRelatorio $relatorio $rede
    echo "Scanner finalizado e relatorio gerado"
}
main