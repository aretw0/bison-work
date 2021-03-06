cmake_minimum_required(VERSION 3.0.0)
project(MathInter)

# Configuração do C++
set(CMAKE_BUILD_TYPE Release)
set(CMAKE_CXX_STANDARD 17)
set(SRC_DIR src)

# Configuração do Flex
find_package(FLEX)
FLEX_TARGET(Lexer ${SRC_DIR}/math.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)

# Configuração do Bison
find_package(BISON)
BISON_TARGET(Parser ${SRC_DIR}/math.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp 
             DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/parser.h)

# Executável depende da saída do Flex e do Bison
include_directories(${CMAKE_CURRENT_BINARY_DIR})
add_executable(${PROJECT_NAME} ${FLEX_Lexer_OUTPUTS} ${BISON_Parser_OUTPUTS})
