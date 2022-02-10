['pragma solidity ^0.6.0;\n', '// SPDX-License-Identifier: UNLICENSED\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' *\n', '*/\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function ceil(uint a, uint m) internal pure returns (uint r) {\n', '    return (a + m - 1) / m * m;\n', '  }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address payable public owner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address payable _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '        emit OwnershipTransferred(msg.sender, _newOwner);\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// ----------------------------------------------------------------------------\n', 'interface IToken {\n', '    function transfer(address to, uint256 tokens) external returns (bool success);\n', '    function burnTokens(uint256 _amount) external;\n', '    function balanceOf(address tokenOwner) external view returns (uint256 balance);\n', '}\n', '\n', '\n', 'contract PreSale is Owned {\n', '    using SafeMath for uint256;\n', '    address public tokenAddress;\n', '    bool public saleOpen;\n', '    uint256 tokenRatePerEth = 25000; \n', '    \n', '    mapping(address => uint256) public usersInvestments;\n', '    \n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function startSale() external onlyOwner{\n', '        require(!saleOpen, "Sale is open");\n', '        saleOpen = true;\n', '    }\n', '    \n', '    function setTokenAddress(address tokenContract) external onlyOwner{\n', '        require(tokenAddress == address(0), "token address already set");\n', '        tokenAddress = tokenContract;\n', '    }\n', '    \n', '    function closeSale() external onlyOwner{\n', '        require(saleOpen, "Sale is not open");\n', '        saleOpen = false;\n', '    }\n', '\n', '    receive() external payable{\n', '        require(saleOpen, "Sale is not open");\n', '        require(usersInvestments[msg.sender].add(msg.value) <= 1 ether, "Max investment allowed is 1 ether");\n', '        \n', '        uint256 tokens = getTokenAmount(msg.value);\n', '        \n', '        require(IToken(tokenAddress).transfer(msg.sender, tokens), "Insufficient balance of sale contract!");\n', '        \n', '        usersInvestments[msg.sender] = usersInvestments[msg.sender].add(msg.value);\n', '        \n', '        // send received funds to the owner\n', '        owner.transfer(msg.value);\n', '    }\n', '    \n', '    function getTokenAmount(uint256 amount) internal view returns(uint256){\n', '        return (amount.mul(tokenRatePerEth)).div(10**2);\n', '    }\n', '    \n', '    function burnUnSoldTokens() external onlyOwner{\n', '        require(!saleOpen, "please close the sale first");\n', '        IToken(tokenAddress).burnTokens(IToken(tokenAddress).balanceOf(address(this)));   \n', '    }\n', '}']