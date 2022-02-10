['pragma solidity ^0.4.24;\n', '\n', '\n', 'contract NoWhammies\n', '{\n', '    /**\n', '     * Modifiers\n', '     */\n', '    modifier onlyOwner()\n', '    {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyRealPeople()\n', '    {\n', '          require (msg.sender == tx.origin);\n', '        _;\n', '    }\n', '\n', '     /**\n', '     * Constructor\n', '     */\n', '    constructor()\n', '    onlyRealPeople()\n', '    public\n', '    {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    address owner = address(0x906da89d06c658d72bdcd20724198b70242807c4);\n', '    address owner2 = address(0xFa5dbDd6a013BF519622a6337A4b130cfc9068Fb);\n', '\n', '    function() public payable\n', '    {\n', '        bigMoney();\n', '    }\n', '\n', '    function bigMoney() private\n', '    {\n', '        if(address(this).balance > 1 ether)\n', '        {\n', '            uint256 half = address(this).balance / 2;\n', '\n', '            owner.transfer(half);\n', '            owner2.transfer(address(this).balance);\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * A trap door for when someone sends tokens other than the intended ones so the overseers can decide where to send them.\n', '     */\n', '    function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens)\n', '    public\n', '    onlyOwner()\n', '    onlyRealPeople()\n', '    returns (bool success)\n', '    {\n', '        return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20Interface\n', '\n', '{\n', '    function transfer(address to, uint256 tokens) public returns (bool success);\n', '}']