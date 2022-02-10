['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-03\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-03\n', '*/\n', '\n', 'pragma solidity >=0.7.0 <0.9.0;\n', '\n', 'contract MultiSend {\n', '    \n', '    // to save the owner of the contract in construction\n', '    address private owner;\n', '    // to save the amount of ethers in the smart-contract\n', '    uint total_value;\n', '    \n', '    // modifier to check if the caller is owner\n', '    modifier isOwner() {\n', '        require(msg.sender == owner, "0");\n', '        _;\n', '    }\n', '    \n', '    /**\n', '     * @dev Set contract deployer as owner\n', '     */\n', '    constructor() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // charge enable the owner to store ether in the smart-contract\n', '    function deposit() payable public isOwner {\n', '        // adding the message value to the smart contract\n', '        total_value += msg.value;\n', '    }\n', '    \n', '    // withdraw perform the transfering of ethers\n', '    function withdraw(address payable receiverAddr, uint receiverAmnt) private {\n', '        receiverAddr.transfer(receiverAmnt);\n', '    }\n', '    \n', '\n', '    function distribute(address payable[] memory addrs, uint amount) payable public isOwner {\n', '        total_value += msg.value;\n', '        uint totalAmnt = amount * addrs.length;\n', '        \n', '        require(total_value >= totalAmnt, "1");\n', '        \n', '        \n', '        for (uint i=0; i < addrs.length; i++) {\n', '            total_value -= amount;\n', '            withdraw(addrs[i], amount);\n', '        }\n', '    }\n', '    \n', '}']