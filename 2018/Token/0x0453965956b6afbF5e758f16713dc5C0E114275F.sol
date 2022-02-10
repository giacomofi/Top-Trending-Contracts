['/**\n', ' * Do you have any questions or suggestions? Emails us @ support@cryptbond.net\n', ' * \n', ' * ===================== CRYPTBOND NETWORK =======================*\n', '  oooooooo8 oooooooooo ooooo  oooo oooooooooo  ooooooooooo oooooooooo    ooooooo  oooo   oooo ooooooooo   \n', 'o888     88  888    888  888  88    888    888 88  888  88  888    888 o888   888o 8888o  88   888    88o \n', '888          888oooo88     888      888oooo88      888      888oooo88  888     888 88 888o88   888    888 \n', '888o     oo  888  88o      888      888            888      888    888 888o   o888 88   8888   888    888 \n', ' 888oooo88  o888o  88o8   o888o    o888o          o888o    o888ooo888    88ooo88  o88o    88  o888ooo88   \n', '                                                                                                          \n', '        oooo   oooo ooooooooooo ooooooooooo oooo     oooo  ooooooo  oooooooooo  oooo   oooo                       \n', '         8888o  88   888    88  88  888  88  88   88  88 o888   888o 888    888  888  o88                         \n', '         88 888o88   888ooo8        888       88 888 88  888     888 888oooo88   888888                           \n', '         88   8888   888    oo      888        888 888   888o   o888 888  88o    888  88o                         \n', '        o88o    88  o888ooo8888    o888o        8   8      88ooo88  o888o  88o8 o888o o888o                      \n', '*                                                                \n', '* ===============================================================*\n', '**/\n', '/*\n', ' For ICO: 50%\n', '- For Founders: 10% \n', '- For Team: 10% \n', '- For Advisors: 10%\n', '- For Airdrop: 20%\n', '✅ ICO Timeline:\n', '1️⃣ ICO Round 1:\n', ' 1 ETH = 1,000,000 CBN\n', '2️⃣ ICO Round 2:\n', ' 1 ETH = 900,000 CBN\n', '3️⃣ ICO Round 3:\n', ' 1 ETH = 750,000 CBN\n', '4️⃣ICO Round 4:\n', ' 1 ETH = 600,000 CBN\n', '✅ When CBN list on Exchanges:\n', '- All token sold out\n', '- End of ICO\n', '\n', '*/ \n', '\n', '/**\n', ' * @title Crowdsale\n', ' * @dev Crowdsale is a base contract for managing a token crowdsale.\n', ' * Crowdsales have a start and end timestamps, where investors can make\n', ' * token purchases and the crowdsale will assign them tokens based\n', ' * on a token per ETH rate. Funds collected are forwarded to a wallet\n', ' * as they arrive.\n', ' */\n', 'pragma solidity ^0.4.24;\n', ' \n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', ' function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '    \n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '         if(msg.sender != owner){\n', '            revert();\n', '         }\n', '         else{\n', '            require(newOwner != address(0));\n', '            OwnershipTransferred(owner, newOwner);\n', '            owner = newOwner;\n', '         }\n', '             \n', '    }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Standard\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Interface {\n', '     function totalSupply() public constant returns (uint);\n', '     function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '     function transfer(address to, uint tokens) public returns (bool success);\n', '     function approve(address spender, uint tokens) public returns (bool success);\n', '     function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '     event Transfer(address indexed from, address indexed to, uint tokens);\n', '     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract Cryptbond is ERC20Interface,Ownable {\n', '\n', '   using SafeMath for uint256;\n', '    uint256 public totalSupply;\n', '    mapping(address => uint256) tokenBalances;\n', '   \n', '   string public constant name = "Cryptbond";\n', '   string public constant symbol = "CBN";\n', '   uint256 public constant decimals = 0;\n', '\n', '   uint256 public constant INITIAL_SUPPLY = 3000000000;\n', '    address ownerWallet;\n', '   // Owner of account approves the transfer of an amount to another account\n', '   mapping (address => mapping (address => uint256)) allowed;\n', '   event Debug(string message, address addr, uint256 number);\n', '\n', '    function CBN (address wallet) onlyOwner public {\n', '        if(msg.sender != owner){\n', '            revert();\n', '         }\n', '        else{\n', '        ownerWallet=wallet;\n', '        totalSupply = 3000000000;\n', '        tokenBalances[wallet] = 3000000000;   //Since we divided the token into 10^18 parts\n', '        }\n', '    }\n', '    \n', ' /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(tokenBalances[msg.sender]>=_value);\n', '    tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);\n', '    tokenBalances[_to] = tokenBalances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '  \n', '  \n', '     /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= tokenBalances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    tokenBalances[_from] = tokenBalances[_from].sub(_value);\n', '    tokenBalances[_to] = tokenBalances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', ' \n', '    uint price = 0.000001 ether;\n', '    function() public payable {\n', '        \n', '        uint toMint = msg.value/price;\n', '        //totalSupply += toMint;\n', '        tokenBalances[msg.sender]+=toMint;\n', '        Transfer(0,msg.sender,toMint);\n', '        \n', '     }     \n', '     /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '     // ------------------------------------------------------------------------\n', '     // Total supply\n', '     // ------------------------------------------------------------------------\n', '     function totalSupply() public constant returns (uint) {\n', '         return totalSupply  - tokenBalances[address(0)];\n', '     }\n', '     \n', '     // ------------------------------------------------------------------------\n', '     // Returns the amount of tokens approved by the owner that can be\n', "     // transferred to the spender's account\n", '     // ------------------------------------------------------------------------\n', '     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '         return allowed[tokenOwner][spender];\n', '     }\n', '     // ------------------------------------------------------------------------\n', '     // Accept ETH\n', '     // ------------------------------------------------------------------------\n', '   function withdraw() onlyOwner public {\n', '        if(msg.sender != owner){\n', '            revert();\n', '         }\n', '         else{\n', '        uint256 etherBalance = this.balance;\n', '        owner.transfer(etherBalance);\n', '         }\n', '    }\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '    return tokenBalances[_owner];\n', '  }\n', '\n', '    function pullBack(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {\n', '        require(tokenBalances[buyer]<=tokenAmount);\n', '        tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);\n', '        tokenBalances[wallet] = tokenBalances[wallet].add(tokenAmount);\n', '        Transfer(buyer, wallet, tokenAmount);\n', '     }\n', '    function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {\n', '        tokenBalance = tokenBalances[addr];\n', '    }\n', '}']