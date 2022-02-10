['pragma solidity ^0.4.25;\n', '\n', '\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '}\n', '\n', '\n', 'contract Disperse {\n', '    function disperseEther(address[] recipients, uint256[] values) external payable {\n', '        for (uint256 i = 0; i < recipients.length; i++)\n', '            recipients[i].transfer(values[i]);\n', '        uint256 balance = address(this).balance;\n', '        if (balance > 0)\n', '            msg.sender.transfer(balance);\n', '    }\n', '\n', '    function disperseToken(IERC20 token, address[] recipients, uint256[] values) external {\n', '        uint256 total = 0;\n', '        for (uint256 i = 0; i < recipients.length; i++)\n', '            total += values[i];\n', '        require(token.transferFrom(msg.sender, address(this), total));\n', '        for (i = 0; i < recipients.length; i++)\n', '            require(token.transfer(recipients[i], values[i]));\n', '    }\n', '\n', '    function disperseTokenSimple(IERC20 token, address[] recipients, uint256[] values) external {\n', '        for (uint256 i = 0; i < recipients.length; i++)\n', '            require(token.transferFrom(msg.sender, recipients[i], values[i]));\n', '    }\n', '}']