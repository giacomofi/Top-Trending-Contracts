['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-06\n', '*/\n', '\n', 'pragma solidity >=0.7.0 <0.8.0;\n', '\n', '/**\n', '    * @notice this interface is taken from indexed-core commit hash dae7f231d0f58bfc0993f6c01199cd6b74b01895\n', ' */\n', 'interface IndexPoolI {\n', '  function getDenormalizedWeight(address token) external view returns (uint256);\n', '  function getBalance(address token) external view returns (uint256);\n', '  function getUsedBalance(address token) external view returns (uint256);\n', '  function getSpotPrice(address tokenIn, address tokenOut) external view returns (uint256);    \n', '}\n', '\n', 'interface ERC20I {\n', '    function totalSupply() external view returns (uint256);\n', '}\n', '\n', '/**\n', '    * @notice SimpleMultiCall is a multicall-like contract for reading IndexPool information\n', '    * @notice it is intended to minimize the need for manual abi encoding/decoding\n', "    * @notice and leverage Golang's abigen to do the heavy lifting\n", ' */\n', 'contract SimpleMultiCall {\n', '\n', '    // index pool methods\n', '\n', '    function getDenormalizedWeights(\n', '        address poolAddress,\n', '        address[] memory tokens\n', '    ) \n', '        public \n', '        view\n', '        returns (address[] memory, uint256[] memory) \n', '    {\n', '        uint256[] memory weights = new uint256[](tokens.length);\n', '        for (uint256 i = 0; i < tokens.length; i++) {\n', '            weights[i] = IndexPoolI(poolAddress).getDenormalizedWeight(tokens[i]);\n', '        }\n', '        return (tokens, weights);\n', '    }\n', '\n', '    function getBalances(\n', '        address poolAddress,\n', '        address[] memory tokens\n', '    ) \n', '        public \n', '        view\n', '        returns (address[] memory, uint256[] memory) \n', '    {\n', '        uint256[] memory balances = new uint256[](tokens.length);\n', '        for (uint256 i = 0; i < tokens.length; i++) {\n', '            balances[i] = IndexPoolI(poolAddress).getBalance(tokens[i]);\n', '        }\n', '        return (tokens, balances);\n', '    }\n', '\n', '    function getUsedBalances(\n', '        address poolAddress,\n', '        address[] memory tokens\n', '    ) \n', '        public \n', '        view\n', '        returns (address[] memory, uint256[] memory) \n', '    {\n', '        uint256[] memory balances = new uint256[](tokens.length);\n', '        for (uint256 i = 0; i < tokens.length; i++) {\n', '            balances[i] = IndexPoolI(poolAddress).getUsedBalance(tokens[i]);\n', '        }\n', '        return (tokens, balances);\n', '    }\n', '\n', '    function getSpotPrices(\n', '        address poolAddress,\n', '        address[] memory inTokens,\n', '        address[] memory outTokens\n', '    )\n', '        public\n', '        view \n', '        returns (address[] memory, address[] memory, uint256[] memory)\n', '    {\n', '        require(inTokens.length == outTokens.length);\n', '        uint256[] memory prices = new uint256[](inTokens.length);\n', '        for (uint256 i = 0; i < inTokens.length; i++) {\n', '            prices[i] = IndexPoolI(poolAddress).getSpotPrice(inTokens[i], outTokens[i]);\n', '        }\n', '        return (inTokens, outTokens, prices);\n', '    }\n', '\n', '    // erc20 methods\n', '\n', '    function getTotalSupplies(\n', '        address[] memory tokens\n', '    )\n', '        public\n', '        view\n', '        returns (address[] memory, uint256[] memory)\n', '    {\n', '        uint256[] memory supplies = new uint256[](tokens.length);\n', '        for (uint256 i = 0; i < tokens.length; i++) {\n', '            supplies[i] = ERC20I(tokens[i]).totalSupply();\n', '        }\n', '        return (tokens, supplies);\n', '    }\n', '}']