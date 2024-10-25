somar(){ 
    echo "----------------------------------------------------"
    echo "                    A D I Ç Ã O                     "
    echo "----------------------------------------------------"
    echo $(($1+$2)); 
}
subtrair(){ 
    echo "----------------------------------------------------"
    echo "                 S U B T R A Ç Ã O                  "
    echo "----------------------------------------------------"
    echo $(($1-$2)); 
}
multiplicar(){ 
    echo "----------------------------------------------------"
    echo "             M U L T I P L I C A Ç Ã O              "
    echo "----------------------------------------------------"
    echo $(($1*$2)); 
}
dividir(){ 
    echo "----------------------------------------------------"
    echo "                   D I V I S Ã O                    "
    echo "----------------------------------------------------"
    if [ "$2" -eq 0 ]; then echo "Erro: divisão por zero"
    else echo $(($1/$2)); fi
}
porcentagem() {
    echo "----------------------------------------------------"
    echo "              P O R C E N T A G E N S               "
    echo "----------------------------------------------------"
    local A=$1; local B=$2; local C=$3;
    if [ "$C" -eq 0 ]; then echo "Erro: Divisão por zero"
    else
        resultado=$(echo "scale=2; ($A * $B) / $C" | bc)
        echo "$resultado"; 
    fi
}

main(){
    while true
    do
        echo "-----------------------------------------------------------------------"
        echo "Obs: somente 2 termos"
        echo "[1] - Somar       | [2] - Subtrair  | [3] - Multiplicar | [4] - Dividir"
        echo "[5] - Porcentagem | [6] - Quit"
        read -p "-> " option

        if [ "$option" = "1" ]; then 
            read -p "Termo A: " termA
            read -p "Termo B: " termB
            resultado=$(somar "$termA" "$termB")
            echo "Resultado: $resultado"
        elif [ "$option" = "2" ]; then
            read -p "Termo A: " termA
            read -p "Termo B: " termB
            resultado=$(subtrair "$termA" "$termB")
            echo "Resultado: $resultado"
        elif [ "$option" = "3" ]; then
            read -p "Termo A: " termA
            read -p "Termo B: " termB
            resultado=$(multiplicar "$termA" "$termB")
            echo "Resultado: $resultado"
        elif [ "$option" = "4" ]; then
            read -p "Termo A: " termA
            read -p "Termo B: " termB
            resultado=$(dividir "$termA" "$termB")
            echo "Resultado: $resultado"
        elif [ "$option" = "5" ]; then 
            # o -e permite com que o echo interprete a quebra de linha
            echo -e "Exemplo: \n termoA ---- termoC\n x-----------termoB\n x=(termoA*termoB) / termoC"
            read -p "1o termo: " termoA
            read -p "2o termo: " termoB
            read -p "3o termo: " termoC
            resultado=$(porcentagem "$termoA" "$termoB" "$termoC")
            echo "Resultado: $resultado"
        elif [ "$option" = "6" ]; then echo "quiting .. ."; break;
        else echo "Informação invalida"
        fi
    done
}
main