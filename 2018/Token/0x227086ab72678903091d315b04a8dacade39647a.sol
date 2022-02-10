['pragma solidity ^0.4.20;\n', '\n', '/// @title kryptono exchange AirDropContract for KNOW token\n', '/// @author Trong Cau Ta <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="f682849998919597839e959b8385b6919b979f9ad895999b">[email&#160;protected]</a>>\n', '/// For more information, please visit kryptono.exchange\n', '\n', '/// @title ERC20\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function balanceOf(address who) view public returns (uint256);\n', '    function allowance(address owner, address spender) view public returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '}\n', '\n', 'contract AirDropContract {\n', '\n', '    event AirDropped(address addr, uint amount);\n', '    address public owner = 0x00a107483c8a16a58871182a48d4ba1fbbb6a64c71;\n', '\n', '    function drop(\n', '        address tokenAddress,\n', '        address[] recipients,\n', '        uint256[] amounts) public {\n', '        require(msg.sender == owner);\n', '        require(tokenAddress != 0x0);\n', '        require(amounts.length == recipients.length);\n', '\n', '        ERC20 token = ERC20(tokenAddress);\n', '\n', '        uint balance = token.balanceOf(msg.sender);\n', '        uint allowance = token.allowance(msg.sender, address(this));\n', '        uint available = balance > allowance ? allowance : balance;\n', '\n', '        for (uint i = 0; i < recipients.length; i++) {\n', '            require(available >= amounts[i]);\n', '            if (isQualitifiedAddress(\n', '                recipients[i]\n', '            )) {\n', '                available -= amounts[i];\n', '                require(token.transferFrom(msg.sender, recipients[i], amounts[i]));\n', '\n', '                AirDropped(recipients[i], amounts[i]);\n', '            }\n', '        }\n', '    }\n', '\n', '    function isQualitifiedAddress(address addr)\n', '        public\n', '        view\n', '        returns (bool result)\n', '    {\n', '        result = addr != 0x0 && addr != msg.sender && !isContract(addr);\n', '    }\n', '\n', '    function isContract(address addr) internal view returns (bool) {\n', '        uint size;\n', '        assembly { size := extcodesize(addr) }\n', '        return size > 0;\n', '    }\n', '\n', '    function () payable public {\n', '        revert();\n', '    }\n', '    \n', '    // withdraw any ERC20 token in this contract to owner\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {\n', '        return ERC20(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']
['pragma solidity ^0.4.20;\n', '\n', '/// @title kryptono exchange AirDropContract for KNOW token\n', '/// @author Trong Cau Ta <trongcauhcmus@gmail.com>\n', '/// For more information, please visit kryptono.exchange\n', '\n', '/// @title ERC20\n', 'contract ERC20 {\n', '    uint public totalSupply;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function balanceOf(address who) view public returns (uint256);\n', '    function allowance(address owner, address spender) view public returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '}\n', '\n', 'contract AirDropContract {\n', '\n', '    event AirDropped(address addr, uint amount);\n', '    address public owner = 0x00a107483c8a16a58871182a48d4ba1fbbb6a64c71;\n', '\n', '    function drop(\n', '        address tokenAddress,\n', '        address[] recipients,\n', '        uint256[] amounts) public {\n', '        require(msg.sender == owner);\n', '        require(tokenAddress != 0x0);\n', '        require(amounts.length == recipients.length);\n', '\n', '        ERC20 token = ERC20(tokenAddress);\n', '\n', '        uint balance = token.balanceOf(msg.sender);\n', '        uint allowance = token.allowance(msg.sender, address(this));\n', '        uint available = balance > allowance ? allowance : balance;\n', '\n', '        for (uint i = 0; i < recipients.length; i++) {\n', '            require(available >= amounts[i]);\n', '            if (isQualitifiedAddress(\n', '                recipients[i]\n', '            )) {\n', '                available -= amounts[i];\n', '                require(token.transferFrom(msg.sender, recipients[i], amounts[i]));\n', '\n', '                AirDropped(recipients[i], amounts[i]);\n', '            }\n', '        }\n', '    }\n', '\n', '    function isQualitifiedAddress(address addr)\n', '        public\n', '        view\n', '        returns (bool result)\n', '    {\n', '        result = addr != 0x0 && addr != msg.sender && !isContract(addr);\n', '    }\n', '\n', '    function isContract(address addr) internal view returns (bool) {\n', '        uint size;\n', '        assembly { size := extcodesize(addr) }\n', '        return size > 0;\n', '    }\n', '\n', '    function () payable public {\n', '        revert();\n', '    }\n', '    \n', '    // withdraw any ERC20 token in this contract to owner\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {\n', '        return ERC20(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']