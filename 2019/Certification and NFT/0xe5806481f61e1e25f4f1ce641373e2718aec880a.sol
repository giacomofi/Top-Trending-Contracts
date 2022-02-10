['pragma solidity ^0.4.22;\n', '\n', '/**\n', '* Contract that will forward any incoming Ether to a receiver address\n', '*/\n', 'contract Forwarder {\n', '    // Address to which any funds sent to this contract will be forwarded\n', '    address public destinationAddress;\n', '    \n', '    // Events allow light clients to react on\n', '    // changes efficiently.\n', '    event Forward(address from, address to, uint amount);\n', '    \n', '    /**\n', '    * Create the contract, and set the destination address to that of the creator\n', '    */\n', '    constructor(address receiver) public {\n', '        destinationAddress = receiver;\n', '    }\n', '    \n', '    /**\n', '    * Default function; Gets called when Ether is deposited, and forwards it to the destination address\n', '    */\n', '    function() public payable {\n', '        if (!destinationAddress.send(msg.value))\n', '            revert();\n', '        \n', '        emit Forward(msg.sender, destinationAddress, msg.value);\n', '    }\n', '}']