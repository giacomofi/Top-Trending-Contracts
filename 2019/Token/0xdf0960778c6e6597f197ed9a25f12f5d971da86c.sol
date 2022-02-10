['pragma solidity ^0.4.25;\n', '\n', '/**\n', ' * \n', ' * World War Goo - Competitive Idle Game\n', ' * \n', ' * https:/ethergoo.io\n', ' * \n', ' */\n', '\n', 'interface ERC20 {\n', '    function totalSupply() external constant returns (uint);\n', '    function balanceOf(address tokenOwner) external constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) external constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) external returns (bool success);\n', '    function approve(address spender, uint tokens) external returns (bool success);\n', '    function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) external returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'interface ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) external;\n', '}\n', '\n', 'contract GooToken is ERC20 {\n', '    using SafeMath for uint;\n', '    using SafeMath224 for uint224;\n', '    \n', '    string public constant name  = "Vials of Goo";\n', '    string public constant symbol = "GOO";\n', '    uint8 public constant decimals = 12;\n', '    uint224 public constant MAX_SUPPLY = 21000000 * (10 ** 12); // 21 million (to 12 szabo decimals)\n', '    \n', '    mapping(address => UserBalance) balances;\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '    \n', "    mapping(address => uint256) public gooProduction; // Store player's current goo production\n", '    mapping(address => bool) operator;\n', '    \n', '    uint224 private totalGoo;\n', '    uint256 public teamAllocation; // 10% reserve allocation towards exchange-listing negotiations, game costs, and ongoing community contests/aidrops\n', '    address public owner; // Minor management of game\n', '    bool public supplyCapHit; // No more production once we hit MAX_SUPPLY\n', '    \n', '    struct UserBalance {\n', '        uint224 goo;\n', '        uint32 lastGooSaveTime;\n', '    }\n', '    \n', '    constructor() public {\n', '        teamAllocation = MAX_SUPPLY / 10;\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function totalSupply() external view returns(uint) {\n', '        return totalGoo;\n', '    }\n', '    \n', '    function transfer(address to, uint256 tokens) external returns (bool) {\n', '        updatePlayersGooInternal(msg.sender);\n', '        \n', '        require(tokens <= MAX_SUPPLY); // Prevent uint224 overflow\n', "        uint224 amount = uint224(tokens); // Goo is uint224 but must comply to ERC20's uint256\n", '\n', '        balances[msg.sender].goo = balances[msg.sender].goo.sub(amount);\n', '        emit Transfer(msg.sender, to, amount);\n', '        \n', '        if (to == address(0)) { // Burn\n', '            totalGoo -= amount;\n', '        } else {\n', '            balances[to].goo = balances[to].goo.add(amount);\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address from, address to, uint256 tokens) external returns (bool) {\n', '        updatePlayersGooInternal(from);\n', '        \n', '        require(tokens <= MAX_SUPPLY); // Prevent uint224 overflow\n', "        uint224 amount = uint224(tokens); // Goo is uint224 but must comply to ERC20's uint256\n", '        \n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);\n', '        balances[from].goo = balances[from].goo.sub(amount);\n', '        emit Transfer(from, to, amount);\n', '        \n', '        if (to == address(0)) { // Burn\n', '            totalGoo -= amount;\n', '        } else {\n', '            balances[to].goo = balances[to].goo.add(amount);\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    function unlockAllocation(uint224 amount, address recipient) external {\n', '        require(msg.sender == owner);\n', '        teamAllocation = teamAllocation.sub(amount); // Hard limit\n', '        \n', '        totalGoo += amount;\n', '        balances[recipient].goo = balances[recipient].goo.add(amount);\n', '        emit Transfer(address(0), recipient, amount);\n', '    }\n', '    \n', '    function setOperator(address gameContract, bool isOperator) external {\n', '        require(msg.sender == owner);\n', '        operator[gameContract] = isOperator;\n', '    }\n', '    \n', '    function approve(address spender, uint256 tokens) external returns (bool) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '    \n', '    function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address tokenOwner, address spender) external view returns (uint256) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '    function recoverAccidentalTokens(address tokenAddress, uint256 tokens) external {\n', '        require(msg.sender == owner);\n', '        require(tokenAddress != address(this)); // Not Goo\n', '        ERC20(tokenAddress).transfer(owner, tokens);\n', '    }\n', '    \n', '    function balanceOf(address player) public constant returns(uint256) {\n', '        return balances[player].goo + balanceOfUnclaimedGoo(player);\n', '    }\n', '    \n', '    function balanceOfUnclaimedGoo(address player) internal constant returns (uint224 gooGain) {\n', '        if (supplyCapHit) return;\n', '        \n', '        uint32 lastSave = balances[player].lastGooSaveTime;\n', '        if (lastSave > 0 && lastSave < block.timestamp) {\n', '            gooGain = uint224(gooProduction[player] * (block.timestamp - lastSave));\n', '        }\n', '        \n', '        if (totalGoo + gooGain >= MAX_SUPPLY) {\n', '            gooGain = MAX_SUPPLY - totalGoo;\n', '        }\n', '    }\n', '    \n', '    function mintGoo(uint224 amount, address player) external {\n', '        if (supplyCapHit) return;\n', '        require(operator[msg.sender]);\n', '        \n', '        uint224 minted = amount;\n', '        if (totalGoo.add(amount) >= MAX_SUPPLY) {\n', '            supplyCapHit = true;\n', '            minted = MAX_SUPPLY - totalGoo;\n', '        }\n', '\n', '        balances[player].goo += minted;\n', '        totalGoo += minted;\n', '        emit Transfer(address(0), player, minted);\n', '    }\n', '    \n', '    function updatePlayersGoo(address player) external {\n', '        require(operator[msg.sender]);\n', '        updatePlayersGooInternal(player);\n', '    }\n', '    \n', '    function updatePlayersGooInternal(address player) internal {\n', '        uint224 gooGain = balanceOfUnclaimedGoo(player);\n', '        \n', '        UserBalance memory balance = balances[player];\n', '        if (gooGain > 0) {\n', '            totalGoo += gooGain;\n', '            if (!supplyCapHit && totalGoo == MAX_SUPPLY) {\n', '                supplyCapHit = true;\n', '            }\n', '            \n', '            balance.goo += gooGain;\n', '            emit Transfer(address(0), player, gooGain);\n', '        }\n', '        \n', '        if (balance.lastGooSaveTime < block.timestamp) {\n', '            balance.lastGooSaveTime = uint32(block.timestamp); \n', '            balances[player] = balance;\n', '        }\n', '    }\n', '    \n', '    function updatePlayersGooFromPurchase(address player, uint224 purchaseCost) external {\n', '        require(operator[msg.sender]);\n', '        uint224 unclaimedGoo = balanceOfUnclaimedGoo(player);\n', '        \n', '        UserBalance memory balance = balances[player];\n', '        balance.lastGooSaveTime = uint32(block.timestamp); \n', '        \n', '        if (purchaseCost > unclaimedGoo) {\n', '            uint224 gooDecrease = purchaseCost - unclaimedGoo;\n', '            totalGoo -= gooDecrease;\n', '            balance.goo = balance.goo.sub(gooDecrease);\n', '            emit Transfer(player, address(0), gooDecrease);\n', '        } else {\n', '            uint224 gooGain = unclaimedGoo - purchaseCost;\n', '            totalGoo += gooGain;\n', '            balance.goo += gooGain;\n', '            if (!supplyCapHit && totalGoo == MAX_SUPPLY) {\n', '                supplyCapHit = true;\n', '            }\n', '            emit Transfer(address(0), player, gooGain);\n', '        }\n', '        balances[player] = balance;\n', '    }\n', '    \n', '    function increasePlayersGooProduction(address player, uint256 increase) external {\n', '        require(operator[msg.sender]);\n', '        gooProduction[player] += increase;\n', '    }\n', '    \n', '    function decreasePlayersGooProduction(address player, uint256 decrease) external {\n', '        require(operator[msg.sender]);\n', '        gooProduction[player] -= decrease;\n', '    }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', 'library SafeMath224 {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint224 a, uint224 b) internal pure returns (uint224) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint224 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint224 a, uint224 b) internal pure returns (uint224) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint224 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint224 a, uint224 b) internal pure returns (uint224) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint224 a, uint224 b) internal pure returns (uint224) {\n', '    uint224 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']