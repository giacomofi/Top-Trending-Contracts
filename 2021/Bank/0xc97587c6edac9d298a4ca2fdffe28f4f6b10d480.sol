['// SPDX-License-Identifier: GPL3\n', 'pragma solidity 0.8.0;\n', '\n', "import './MateriaOperator.sol';\n", "import './IMateriaOrchestrator.sol';\n", "import './IMateriaPair.sol';\n", "import './IERC20.sol';\n", "import './IERC20WrapperV1.sol';\n", '\n', "import './MateriaLibrary.sol';\n", '\n', 'contract MateriaLiquidityRemover is MateriaOperator {\n', '    function removeLiquidity(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 tokenAmountMin,\n', '        uint256 bridgeAmountMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) public ensure(deadline) returns (uint256 amountBridge, uint256 amountToken) {\n', '        address erc20Wrapper = address(IMateriaOrchestrator(address(this)).erc20Wrapper());\n', '        address bridgeToken = address(IMateriaOrchestrator(address(this)).bridgeToken());\n', '        address pair;\n', '\n', '        {\n', '            (bool ethItem, uint256 itemId) = _isEthItem(token, erc20Wrapper);\n', '            token = ethItem ? token : address(IERC20WrapperV1(erc20Wrapper).asInteroperable(itemId));\n', '            pair = MateriaLibrary.pairFor(address(IMateriaOrchestrator(address(this)).factory()), token, bridgeToken);\n', '        }\n', '\n', '        IMateriaPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair\n', '        (uint256 amount0, uint256 amount1) = IMateriaPair(pair).burn(to);\n', '        (address token0, ) = MateriaLibrary.sortTokens(token, bridgeToken);\n', '        (amountBridge, amountToken) = token0 == address(bridgeToken) ? (amount0, amount1) : (amount1, amount0);\n', "        require(amountBridge >= bridgeAmountMin, 'INSUFFICIENT_BRIDGE_AMOUNT');\n", "        require(amountToken >= tokenAmountMin, 'INSUFFICIENT_TOKEN_AMOUNT');\n", '    }\n', '\n', '    function removeLiquidityETH(\n', '        uint256 liquidity,\n', '        uint256 bridgeAmountMin,\n', '        uint256 ethAmountMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) public ensure(deadline) returns (uint256 amountBridge, uint256 amountEth) {\n', '        address erc20Wrapper = address(IMateriaOrchestrator(address(this)).erc20Wrapper());\n', '        address bridgeToken = address(IMateriaOrchestrator(address(this)).bridgeToken());\n', '        address ieth = _tokenToInteroperable(address(0), erc20Wrapper);\n', '\n', '        address pair =\n', '            MateriaLibrary.pairFor(address(IMateriaOrchestrator(address(this)).factory()), ieth, bridgeToken);\n', '\n', '        IMateriaPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair\n', '        (uint256 amount0, uint256 amount1) = IMateriaPair(pair).burn(address(this));\n', '        (address token0, ) = MateriaLibrary.sortTokens(ieth, address(bridgeToken));\n', '        (amountBridge, amountEth) = token0 == address(bridgeToken) ? (amount0, amount1) : (amount1, amount0);\n', "        require(amountBridge >= bridgeAmountMin, 'INSUFFICIENT_BRIDGE_AMOUNT');\n", "        require(amountEth >= ethAmountMin, 'INSUFFICIENT_TOKEN_AMOUNT');\n", '        _unwrapEth(uint256(IMateriaOrchestrator(address(this)).ETHEREUM_OBJECT_ID()), amountEth, erc20Wrapper, to);\n', '    }\n', '\n', '    function removeLiquidityWithPermit(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 tokenAmountMin,\n', '        uint256 bridgeAmountMin,\n', '        address to,\n', '        uint256 deadline,\n', '        bool approveMax,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external {\n', '        address factory = address(IMateriaOrchestrator(address(this)).factory());\n', '        address bridgeToken = address(IMateriaOrchestrator(address(this)).bridgeToken());\n', '\n', '        address pair = MateriaLibrary.pairFor(factory, bridgeToken, token);\n', '        uint256 value = approveMax ? type(uint256).max : liquidity;\n', '        IMateriaPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);\n', '        removeLiquidity(token, liquidity, tokenAmountMin, bridgeAmountMin, to, deadline);\n', '    }\n', '\n', '    function removeLiquidityETHWithPermit(\n', '        uint256 liquidity,\n', '        uint256 tokenAmountMin,\n', '        uint256 bridgeAmountMin,\n', '        address to,\n', '        uint256 deadline,\n', '        bool approveMax,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external {\n', '        address factory = address(IMateriaOrchestrator(address(this)).factory());\n', '        address bridgeToken = address(IMateriaOrchestrator(address(this)).bridgeToken());\n', '        address erc20Wrapper = address(IMateriaOrchestrator(address(this)).erc20Wrapper());\n', '\n', '        address pair = MateriaLibrary.pairFor(factory, bridgeToken, _tokenToInteroperable(address(0), erc20Wrapper));\n', '        uint256 value = approveMax ? type(uint256).max : liquidity;\n', '        IMateriaPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);\n', '        removeLiquidityETH(liquidity, bridgeAmountMin, tokenAmountMin, to, deadline);\n', '    }\n', '\n', '    function onERC1155Received(\n', '        address,\n', '        address,\n', '        uint256,\n', '        uint256,\n', '        bytes calldata\n', '    ) public pure override returns (bytes4) {\n', '        revert();\n', '    }\n', '\n', '    function onERC1155BatchReceived(\n', '        address,\n', '        address,\n', '        uint256[] calldata,\n', '        uint256[] calldata,\n', '        bytes calldata\n', '    ) public pure override returns (bytes4) {\n', '        revert();\n', '    }\n', '\n', '    function supportsInterface(bytes4) public pure override returns (bool) {\n', '        return false;\n', '    }\n', '}']