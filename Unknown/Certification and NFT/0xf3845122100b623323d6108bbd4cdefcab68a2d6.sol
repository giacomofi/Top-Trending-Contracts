['pragma solidity ^0.4.15;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract EthMessage is Ownable {\n', '\n', '    /*\n', '    The cost of posting a message will be currentPrice.\n', '\n', '    The currentPrice will increase by basePrice every time a message is bought.\n', '    */\n', '\n', '    uint public constant BASEPRICE = 0.01 ether;\n', '    uint public currentPrice = 0.01 ether;\n', '    string public message = "";\n', '\n', '    function withdraw() public payable onlyOwner {\n', '        msg.sender.transfer(this.balance);\n', '    }\n', '    \n', '    // This is only for messed up things people put.\n', '    function removeMessage() onlyOwner public {\n', '        message = "";\n', '    }\n', '\n', '    modifier requiresPayment () {\n', '        require(msg.value >= currentPrice);\n', '        if (msg.value > currentPrice) {\n', '            msg.sender.transfer(msg.value - currentPrice);\n', '        }\n', '        currentPrice += BASEPRICE;\n', '        _;\n', '    }\n', '\n', '    function putMessage(string messageToPut) public requiresPayment payable {\n', '        if (bytes(messageToPut).length > 255) {\n', '            revert();\n', '        }\n', '        message = messageToPut;\n', '    }\n', '\n', '    function () {\n', '        revert();\n', '    }\n', '}']