['pragma solidity ^0.4.24;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount) external;\n', '}\n', '\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract ZenswapDistribution is Ownable {\n', '    \n', '    token public tokenReward;\n', '    \n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Set the token smart contract address\n', '     */\n', '    constructor() public {\n', '        \n', '        tokenReward = token(0x0D1C63E12fDE9e5cADA3E272576183AbA9cfedA2);\n', '        \n', '    }\n', '    \n', '    /**\n', '     * Distribute token to multiple address\n', '     * \n', '     */\n', '    function distributeToken(address[] _addresses, uint256[] _amount) public onlyOwner {\n', '    \n', '    uint256 addressCount = _addresses.length;\n', '    uint256 amountCount = _amount.length;\n', '    require(addressCount == amountCount);\n', '    \n', '    for (uint256 i = 0; i < addressCount; i++) {\n', '        uint256 _tokensAmount = _amount[i] * 10 ** uint256(18);\n', '        tokenReward.transfer(_addresses[i], _tokensAmount);\n', '    }\n', '  }\n', '\n', '    /**\n', '     * Withdraw an "amount" of available tokens in the contract\n', '     * \n', '     */\n', '    function withdrawToken(address _address, uint256 _amount) public onlyOwner {\n', '        \n', '        uint256 _tokensAmount = _amount * 10 ** uint256(18); \n', '        tokenReward.transfer(_address, _tokensAmount);\n', '    }\n', '    \n', '    /**\n', '     * Set a token contract address\n', '     * \n', '     */\n', '    function setTokenReward(address _address) public onlyOwner {\n', '        \n', '        tokenReward = token(_address);\n', '    }\n', '    \n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'interface token {\n', '    function transfer(address receiver, uint amount) external;\n', '}\n', '\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', 'contract ZenswapDistribution is Ownable {\n', '    \n', '    token public tokenReward;\n', '    \n', '    /**\n', '     * Constructor function\n', '     *\n', '     * Set the token smart contract address\n', '     */\n', '    constructor() public {\n', '        \n', '        tokenReward = token(0x0D1C63E12fDE9e5cADA3E272576183AbA9cfedA2);\n', '        \n', '    }\n', '    \n', '    /**\n', '     * Distribute token to multiple address\n', '     * \n', '     */\n', '    function distributeToken(address[] _addresses, uint256[] _amount) public onlyOwner {\n', '    \n', '    uint256 addressCount = _addresses.length;\n', '    uint256 amountCount = _amount.length;\n', '    require(addressCount == amountCount);\n', '    \n', '    for (uint256 i = 0; i < addressCount; i++) {\n', '        uint256 _tokensAmount = _amount[i] * 10 ** uint256(18);\n', '        tokenReward.transfer(_addresses[i], _tokensAmount);\n', '    }\n', '  }\n', '\n', '    /**\n', '     * Withdraw an "amount" of available tokens in the contract\n', '     * \n', '     */\n', '    function withdrawToken(address _address, uint256 _amount) public onlyOwner {\n', '        \n', '        uint256 _tokensAmount = _amount * 10 ** uint256(18); \n', '        tokenReward.transfer(_address, _tokensAmount);\n', '    }\n', '    \n', '    /**\n', '     * Set a token contract address\n', '     * \n', '     */\n', '    function setTokenReward(address _address) public onlyOwner {\n', '        \n', '        tokenReward = token(_address);\n', '    }\n', '    \n', '}']
