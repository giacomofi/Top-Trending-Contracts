['pragma solidity ^0.4.10;\n', '\n', '// NovaExchange Balance Recovery, last email accepted\n', '\n', 'contract balancesImporter1   {\n', '\n', 'address[] public addresses1;\n', 'uint256[] public balances1;\n', '\n', 'function balancesImporter1()    {\n', '\n', 'addresses1=[\n', '0xb536f3a01458a62B49aB7a85FA8cd95e1bA19f56\n', '];\n', '\n', 'balances1=[\n', '28911051359610000000000\n', '];\n', '\n', 'elixor elixorContract=elixor(0x898bf39cd67658bd63577fb00a2a3571daecbc53);\n', 'elixorContract.importAmountForAddresses(balances1,addresses1);\n', '\n', '}\n', '}\n', '\n', 'contract elixor  {\n', '\n', 'function importAmountForAddresses(uint256[] amounts,address[] addressesToAddTo);\n', '\n', '}']