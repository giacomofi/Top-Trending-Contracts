['pragma solidity ^0.4.23;\n', '\n', '// ----------------------------------------------------------------------------\n', '// Want to say something? Use this contract to send some random text from the\n', '// Gnosis multisig wallet or equivalent\n', '//\n', '// Deployed to 0xc0dd00590Ad0Fbffe2f567651D075ea48435Dc89\n', '//\n', '// https://github.com/bokkypoobah/RandomSmartContracts/blob/master/contracts/SayIt.sol\n', '//\n', '// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.\n', '// ----------------------------------------------------------------------------\n', '\n', 'contract ERC20Partial {\n', '    function balanceOf(address owner) public constant returns (uint256 balance);\n', '    function transfer(address to, uint256 value) public returns (bool success);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '    event OwnershipTransferred(address indexed from, address indexed to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        if (msg.sender == newOwner) {\n', '            emit OwnershipTransferred(owner, newOwner);\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract SayIt is Owned {\n', '    event Said(address indexed who, string text);\n', '\n', '    function say(string text) public {\n', '        emit Said(msg.sender, text);\n', '    }\n', '\n', '    function transferOut(address tokenAddress) public onlyOwner {\n', '        if (tokenAddress == address(0)) {\n', '            owner.transfer(address(this).balance);\n', '        } else {\n', '            ERC20Partial token = ERC20Partial(tokenAddress);\n', '            uint balance = token.balanceOf(this);\n', '            token.transfer(owner, balance);\n', '        }\n', '    }\n', '}']