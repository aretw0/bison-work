# bison-work
Trabalho da cadeira de compiladores.

Este trabalho consiste em fazer um interpretador de expressões matemáticas usando as ferramentas *Flex*, *Bison* e
*Makefile* (ou *CMake*) no Linux. O interpretador deve ler um arquivo (ou caracteres da entrada padrão)
que obedeça ao formato abaixo. O resultado deve ser exibido na saída padrão.

O interpretador deve dar suporte às seguintes operações, funções e expressões:
- Operadores aritméticos: +, -, *, / (divisão ponto-flutuante)
- Operadores relacionais: >, <, >=, <=, == e !=
- Funções raiz quadrada (sqrt) e potenciação (pow)
- Expressões parentizadas

E dar suporte às seguintes instruções:
- Atribuição de valor (=)
- Instrução condicional (if)
- Exibição de valores e texto (print)

Exemplos de entradas que devem ser tratadas pelo interpretador:

```bash
n1 = 9.0
n2 = 7.5
n3 = 6.5
parcial = (n1*4 + n2*5 + n3*6) / 15
if (parcial >= 7) print("aprovado")
aprovado
r = sqrt(2)
print("raiz de 2 = ", r)
raiz de 2 = 1.41421
print(pow(r,2))
2
```