['pragma solidity ^0.5.7;\n', '\n', 'import "./ERC20Standard.sol";\n', '\n', 'contract DIGITALDOLLAR is ERC20Standard {\n', '\tconstructor() public {\n', '\t\ttotalSupply = 999000000000000000000;\n', '\t\tname = "Digital Dollar";\n', '\t\tdecimals = 5;\n', '\t\tsymbol = "DDO";\n', '\t\tversion = "1.0";\n', '\t\tbalances[msg.sender] = totalSupply;\n', '\t}\n', '}']