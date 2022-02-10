['\n', '// File: test/contracts/TransferValue.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'interface ERC20Transfer {\n', '  function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '}\n', '\n', '\n', 'contract TransferValue {\n', '    modifier notZero (uint256 value) {\n', '        require(value != 0, "no value can be zero");\n', '        _;\n', '    }\n', '\n', '    function transferETH (\n', '        address payable[] calldata accounts\n', '      ) external payable\n', '      notZero(accounts.length)\n', '      returns(bool)\n', '    {\n', '        // if (amount == 0)\n', '        //   return false;\n', '        uint arrayLength = accounts.length;\n', '\n', '        // if (arrayLength == 0)\n', '        //   return false;\n', '\n', '        uint amountPerAccount = msg.value / arrayLength;\n', '\n', '        for (uint i = 0; i < arrayLength; ++i ) {\n', '            accounts[i].transfer(amountPerAccount);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferToken(\n', '        address token,\n', '        address[] calldata accounts,\n', '        uint256 amount\n', '      ) external\n', '      notZero(uint256(token))\n', '      notZero(accounts.length)\n', '      notZero(amount)\n', '      returns(bool)\n', '    {\n', '        uint arrayLength = accounts.length;\n', '\n', '        uint amountPerAccount = amount / arrayLength;\n', '\n', '        ERC20Transfer tokenContract = ERC20Transfer(token);\n', '\n', '        for (uint i = 0; i < arrayLength; ++i ) {\n', '            tokenContract.transferFrom(msg.sender, accounts[i], amountPerAccount);\n', '        }\n', '\n', '        return true;\n', '    }\n', '}\n']