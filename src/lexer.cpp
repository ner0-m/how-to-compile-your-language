#include "lexer.h"
#include "token.h"

namespace {
bool isSpace(char c) {
  return c == ' ' || c == '\f' || c == '\n' || c == '\r' || c == '\t' ||
         c == '\v';
}

bool isAlpha(char c) { return 'a' <= c && c <= 'z' || 'A' <= c && c <= 'Z'; }
bool isNum(char c) { return '0' <= c && c <= '9'; }
bool isAlnum(char c) { return isAlpha(c) || isNum(c); }

} // namespace

Token TheLexer::getNextToken() {
  char currentChar = eatNextChar();

  while (isSpace(currentChar))
    currentChar = eatNextChar();

  SourceLocation tokenStartLocation = getSourceLocation();

  if (currentChar == '(')
    return Token{tokenStartLocation, TokenKind::lpar};
  if (currentChar == ')')
    return Token{tokenStartLocation, TokenKind::rpar};
  if (currentChar == '{')
    return Token{tokenStartLocation, TokenKind::lbrace};
  if (currentChar == '}')
    return Token{tokenStartLocation, TokenKind::rbrace};
  if (currentChar == ':')
    return Token{tokenStartLocation, TokenKind::colon};
  if (currentChar == ';')
    return Token{tokenStartLocation, TokenKind::semi};
  if (currentChar == ',')
    return Token{tokenStartLocation, TokenKind::comma};
  if (currentChar == '\0')
    return Token{tokenStartLocation, TokenKind::eof};

  if (currentChar == '\'') {
    std::string value;

    while ((currentChar = eatNextChar()) != '\'')
      value += currentChar;

    return Token{tokenStartLocation, TokenKind::string, std::move(value)};
  }

  if (isAlpha(currentChar)) {
    std::string value{currentChar};

    while (isAlnum(peekNextChar()))
      value += eatNextChar();

    if (value == "fn")
      return Token{tokenStartLocation, TokenKind::fn, std::move(value)};

    return Token{tokenStartLocation, TokenKind::identifier, std::move(value)};
  }

  // [0-9]+ . [0-9]+
  if (isNum(currentChar)) {
    std::string value{currentChar};

    while (isNum(peekNextChar()))
      value += eatNextChar();

    if (peekNextChar() != '.')
      return Token{tokenStartLocation, TokenKind::unk};

    value += eatNextChar();

    if (!isNum(peekNextChar()))
      return Token{tokenStartLocation, TokenKind::unk};

    while (isNum(peekNextChar()))
      value += eatNextChar();

    return Token{tokenStartLocation, TokenKind::number, value};
  }

  return Token{tokenStartLocation, TokenKind::unk};
}
