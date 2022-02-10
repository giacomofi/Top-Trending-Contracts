['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "./ERC20MinterPauserCapped.sol";\n', '\n', 'contract SwapperContract {\n', '    \n', '    address private erc20 = 0x396eC402B42066864C406d1ac3bc86B575003ed8;\n', '    address private burner = 0x1C5f60C7e1230895d32e3f4FE8173a970BbAE9C2;\n', '\n', '    event SwapRequest(\n', '        address indexed sender, \n', '        uint256 indexed amount, \n', '        string algorand\n', '    );\n', '\n', '    function doTransfer(uint256 _amount, string memory _algorand) public {\n', '        ERC20MinterPauserCapped erc20Instance = ERC20MinterPauserCapped(erc20);\n', '        erc20Instance.transferFrom(msg.sender, burner, _amount);\n', '        emit SwapRequest(msg.sender, _amount, _algorand);\n', '    }\n', '\n', '}']