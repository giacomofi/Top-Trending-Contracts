['pragma solidity ^0.4.19;\n', '\n', '// the call we make\n', 'interface KittyCoreI {\n', '    function giveBirth(uint256 _matronId) public;\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'contract KittyBirther is Ownable {\n', '    KittyCoreI constant kittyCore = KittyCoreI(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d);\n', '\n', '    function KittyBirther() public {}\n', '\n', '    function withdraw() public onlyOwner {\n', '        owner.transfer(this.balance);\n', '    }\n', '\n', '    function birth(uint blockNumber, uint64[] kittyIds) public {\n', '        if (blockNumber < block.number) {\n', '            return;\n', '        }\n', '\n', '        if (kittyIds.length == 0) {\n', '            return;\n', '        }\n', '\n', '        for (uint i = 0; i < kittyIds.length; i ++) {\n', '            kittyCore.giveBirth(kittyIds[i]);\n', '        }\n', '    }\n', '}']