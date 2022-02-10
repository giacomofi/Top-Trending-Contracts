['pragma solidity ^0.4.18;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount) external;\n', '}\n', '\n', 'contract Crowdsale {\n', '\n', '    uint256 public price;\n', '    token public tokenReward;\n', '    address owner;\n', '    uint256 public amount;\n', '\n', '     modifier onlyCreator() {\n', '        require(msg.sender == owner); // If it is incorrect here, it reverts.\n', '        _;                              // Otherwise, it continues.\n', '    } \n', '    \n', '    constructor(address addressOfTokenUsedAsReward) public {\n', '        owner = msg.sender;\n', '        price = 0.00028 ether;\n', '        tokenReward = token(addressOfTokenUsedAsReward);\n', '    }\n', '    \n', '    function updateOwner(address newOwner) public onlyCreator{\n', '        owner = newOwner;\n', '    }\n', '\n', '    function () payable public {\n', '\n', '        amount = msg.value;\n', '        uint256 tobesent = amount/price;\n', '        tokenReward.transfer(msg.sender, tobesent*10e17);\n', '\n', '    }\n', '\n', '    function safeWithdrawal() public onlyCreator {\n', '            uint amount = address(this).balance;\n', '                owner.send(amount);\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount) external;\n', '}\n', '\n', 'contract Crowdsale {\n', '\n', '    uint256 public price;\n', '    token public tokenReward;\n', '    address owner;\n', '    uint256 public amount;\n', '\n', '     modifier onlyCreator() {\n', '        require(msg.sender == owner); // If it is incorrect here, it reverts.\n', '        _;                              // Otherwise, it continues.\n', '    } \n', '    \n', '    constructor(address addressOfTokenUsedAsReward) public {\n', '        owner = msg.sender;\n', '        price = 0.00028 ether;\n', '        tokenReward = token(addressOfTokenUsedAsReward);\n', '    }\n', '    \n', '    function updateOwner(address newOwner) public onlyCreator{\n', '        owner = newOwner;\n', '    }\n', '\n', '    function () payable public {\n', '\n', '        amount = msg.value;\n', '        uint256 tobesent = amount/price;\n', '        tokenReward.transfer(msg.sender, tobesent*10e17);\n', '\n', '    }\n', '\n', '    function safeWithdrawal() public onlyCreator {\n', '            uint amount = address(this).balance;\n', '                owner.send(amount);\n', '    }\n', '}']
