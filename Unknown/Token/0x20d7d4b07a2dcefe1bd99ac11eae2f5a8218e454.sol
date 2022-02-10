['pragma solidity ^0.4.16;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused returns (bool) {\n', '    paused = true;\n', '    Pause();\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused returns (bool) {\n', '    paused = false;\n', '    Unpause();\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Slot Ticket token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', ' \n', 'contract SlotTicket is StandardToken, Ownable {\n', '\n', '  string public name = "Slot Ticket";\n', '  uint8 public decimals = 0;\n', '  string public symbol = "SLOT";\n', '  string public version = "0.1";\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '\n', '  function mint(address _to, uint256 _amount) onlyOwner returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(0x0, _to, _amount); // so it is displayed properly on EtherScan\n', '    return true;\n', '  }\n', '\n', 'function destroy() onlyOwner {\n', '    // Transfer Eth to owner and terminate contract\n', '    selfdestruct(owner);\n', '  }\n', '\n', '}\n', '\n', 'contract Slot is Ownable, Pausable { // TODO: for production disable tokenDestructible\n', '    using SafeMath for uint256;\n', '\n', '    // this token is just a gimmick to receive when buying a ticket, it wont affect the prize\n', '    SlotTicket public token;\n', '\n', '    // every participant has an account index, the winners are picked from here\n', '    // all winners are picked in order from the single random int \n', '    // needs to be cleared after every game\n', '    mapping (uint => address) participants;\n', '    uint256[] prizes = [4 ether, \n', '                        2 ether,\n', '                        1 ether, \n', '                        500 finney, \n', '                        500 finney, \n', '                        500 finney, \n', '                        500 finney, \n', '                        500 finney];\n', '    uint8 counter = 0;\n', '\n', '    uint8   constant SIZE = 100; // size of the lottery\n', '    uint32  constant JACKPOT_SIZE = 1000000; // one in a million\n', '    uint256 constant PRICE = 100 finney;\n', '    \n', '    uint256 jackpot = 0;\n', '    uint256 gameNumber = 0;\n', '    address wallet;\n', '\n', '    event PrizeAwarded(uint256 game, address winner, uint256 amount);\n', '    event JackpotAwarded(uint256 game, address winner, uint256 amount);\n', '\n', '    function Slot(address _wallet) {\n', '        token = new SlotTicket();\n', '        wallet = _wallet;\n', '    }\n', '\n', '    function() payable {\n', '        // fallback function to buy tickets from\n', '        buyTicketsFor(msg.sender);\n', '    }\n', '\n', '    function buyTicketsFor(address beneficiary) whenNotPaused() payable {\n', '        require(beneficiary != 0x0);\n', '        require(msg.value >= PRICE);\n', '        require(msg.value/PRICE <= 255); // maximum of 255 tickets, to avoid overflow on uint8\n', '        // I can&#39;t see somebody sending more than the size of the lottery, other than to try to win the jackpot\n', '        \n', '        // calculate number of tickets, issue tokens and add participants\n', '        // every 100 finney buys a ticket, the rest is returned\n', '        uint8 numberOfTickets = uint8(msg.value/PRICE); \n', '        token.mint(beneficiary, numberOfTickets);\n', '        addParticipant(beneficiary, numberOfTickets);\n', '\n', '        // Return change to msg.sender\n', '        // TODO: check if change amount correct\n', '        msg.sender.transfer(msg.value%PRICE);\n', '\n', '    }\n', '\n', '    function addParticipant(address _participant, uint8 _numberOfTickets) private {\n', '        // TODO: check access of this function, it shouldn&#39;t be tampered with\n', '        // add participants and increment count\n', '        // should gracefully handle multiple tickets accross games\n', '\n', '        for (uint8 i = 0; i < _numberOfTickets; i++) {\n', '            participants[counter] = _participant;\n', '\n', '            // msg.sender triggers the drawing of lots\n', '            if (counter % (SIZE-1) == 0) { \n', '                // takes the participant&#39;s address as the seed\n', '                awardPrizes(uint256(_participant)); \n', '            } \n', '            \n', '            counter++;\n', '\n', '            // loop continues if there are more tickets\n', '        }\n', '        \n', '    }\n', '    \n', '    function rand(uint32 _size, uint256 _seed) constant private returns (uint32 randomNumber) {\n', '      // Providing random numbers within a deterministic system is, naturally, an impossible task.\n', '      // However, we can approximate with pseudo-random numbers by utilising data which is generally unknowable\n', '      // at the time of transacting. Such data might include the block’s hash.\n', '\n', '        return uint32(sha3(block.blockhash(block.number-1), _seed))%_size;\n', '    }\n', '\n', '    function awardPrizes(uint256 _seed) private {\n', '        uint32 winningNumber = rand(SIZE-1, _seed); // -1 since index starts at 0\n', '        bool jackpotWon = winningNumber == rand(JACKPOT_SIZE-1, _seed); // -1 since index starts at 0\n', '\n', '        // scope of participants\n', '        uint256 start = gameNumber.mul(SIZE);\n', '        uint256 end = start + SIZE;\n', '\n', '        uint256 winnerIndex = start.add(winningNumber);\n', '\n', '        for (uint8 i = 0; i < prizes.length; i++) {\n', '            \n', '            if (jackpotWon && i==0) { distributeJackpot(winnerIndex); }\n', '\n', '            if (winnerIndex+i > end) {\n', '              // to keep within the bounds of participants, wrap around\n', '                winnerIndex -= SIZE;\n', '            }\n', '\n', '            participants[winnerIndex+i].transfer(prizes[i]); // msg.sender pays the gas, he&#39;s refunded later\n', '            \n', '            PrizeAwarded(gameNumber,  participants[winnerIndex+i], prizes[i]);\n', '        }\n', '        \n', '        // Split the rest\n', '        jackpot = jackpot.add(245 finney);  // add to jackpot\n', '        wallet.transfer(245 finney);        // *cash register sound*\n', '        msg.sender.transfer(10 finney);     // repay gas to msg.sender TODO: check if price is right\n', '\n', '        gameNumber++;\n', '    }\n', '\n', '    function distributeJackpot(uint256 _winnerIndex) {\n', '        participants[_winnerIndex].transfer(jackpot);\n', '        JackpotAwarded(gameNumber,  participants[_winnerIndex], jackpot);\n', '        jackpot = 0; // later on in the code money will be added\n', '    }\n', '\n', '    function destroy() onlyOwner {\n', '        // Transfer Eth to owner and terminate contract\n', '        token.destroy();\n', '        selfdestruct(owner);\n', '  }\n', '\n', '    function changeWallet(address _newWallet) onlyOwner {\n', '        require(_newWallet != 0x0);\n', '        wallet = _newWallet;\n', '  }\n', '\n', '}']
['pragma solidity ^0.4.16;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) constant returns (uint256);\n', '  function transfer(address to, uint256 value) returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) returns (bool) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) returns (bool);\n', '  function approve(address spender, uint256 value) returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS paused\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev modifier to allow actions only when the contract IS NOT paused\n', '   */\n', '  modifier whenPaused {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused returns (bool) {\n', '    paused = true;\n', '    Pause();\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused returns (bool) {\n', '    paused = false;\n', '    Unpause();\n', '    return true;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Slot Ticket token\n', ' * @dev Simple ERC20 Token example, with mintable token creation\n', ' * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120\n', ' * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol\n', ' */\n', ' \n', 'contract SlotTicket is StandardToken, Ownable {\n', '\n', '  string public name = "Slot Ticket";\n', '  uint8 public decimals = 0;\n', '  string public symbol = "SLOT";\n', '  string public version = "0.1";\n', '\n', '  event Mint(address indexed to, uint256 amount);\n', '\n', '  function mint(address _to, uint256 _amount) onlyOwner returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    Transfer(0x0, _to, _amount); // so it is displayed properly on EtherScan\n', '    return true;\n', '  }\n', '\n', 'function destroy() onlyOwner {\n', '    // Transfer Eth to owner and terminate contract\n', '    selfdestruct(owner);\n', '  }\n', '\n', '}\n', '\n', 'contract Slot is Ownable, Pausable { // TODO: for production disable tokenDestructible\n', '    using SafeMath for uint256;\n', '\n', '    // this token is just a gimmick to receive when buying a ticket, it wont affect the prize\n', '    SlotTicket public token;\n', '\n', '    // every participant has an account index, the winners are picked from here\n', '    // all winners are picked in order from the single random int \n', '    // needs to be cleared after every game\n', '    mapping (uint => address) participants;\n', '    uint256[] prizes = [4 ether, \n', '                        2 ether,\n', '                        1 ether, \n', '                        500 finney, \n', '                        500 finney, \n', '                        500 finney, \n', '                        500 finney, \n', '                        500 finney];\n', '    uint8 counter = 0;\n', '\n', '    uint8   constant SIZE = 100; // size of the lottery\n', '    uint32  constant JACKPOT_SIZE = 1000000; // one in a million\n', '    uint256 constant PRICE = 100 finney;\n', '    \n', '    uint256 jackpot = 0;\n', '    uint256 gameNumber = 0;\n', '    address wallet;\n', '\n', '    event PrizeAwarded(uint256 game, address winner, uint256 amount);\n', '    event JackpotAwarded(uint256 game, address winner, uint256 amount);\n', '\n', '    function Slot(address _wallet) {\n', '        token = new SlotTicket();\n', '        wallet = _wallet;\n', '    }\n', '\n', '    function() payable {\n', '        // fallback function to buy tickets from\n', '        buyTicketsFor(msg.sender);\n', '    }\n', '\n', '    function buyTicketsFor(address beneficiary) whenNotPaused() payable {\n', '        require(beneficiary != 0x0);\n', '        require(msg.value >= PRICE);\n', '        require(msg.value/PRICE <= 255); // maximum of 255 tickets, to avoid overflow on uint8\n', "        // I can't see somebody sending more than the size of the lottery, other than to try to win the jackpot\n", '        \n', '        // calculate number of tickets, issue tokens and add participants\n', '        // every 100 finney buys a ticket, the rest is returned\n', '        uint8 numberOfTickets = uint8(msg.value/PRICE); \n', '        token.mint(beneficiary, numberOfTickets);\n', '        addParticipant(beneficiary, numberOfTickets);\n', '\n', '        // Return change to msg.sender\n', '        // TODO: check if change amount correct\n', '        msg.sender.transfer(msg.value%PRICE);\n', '\n', '    }\n', '\n', '    function addParticipant(address _participant, uint8 _numberOfTickets) private {\n', "        // TODO: check access of this function, it shouldn't be tampered with\n", '        // add participants and increment count\n', '        // should gracefully handle multiple tickets accross games\n', '\n', '        for (uint8 i = 0; i < _numberOfTickets; i++) {\n', '            participants[counter] = _participant;\n', '\n', '            // msg.sender triggers the drawing of lots\n', '            if (counter % (SIZE-1) == 0) { \n', "                // takes the participant's address as the seed\n", '                awardPrizes(uint256(_participant)); \n', '            } \n', '            \n', '            counter++;\n', '\n', '            // loop continues if there are more tickets\n', '        }\n', '        \n', '    }\n', '    \n', '    function rand(uint32 _size, uint256 _seed) constant private returns (uint32 randomNumber) {\n', '      // Providing random numbers within a deterministic system is, naturally, an impossible task.\n', '      // However, we can approximate with pseudo-random numbers by utilising data which is generally unknowable\n', '      // at the time of transacting. Such data might include the block’s hash.\n', '\n', '        return uint32(sha3(block.blockhash(block.number-1), _seed))%_size;\n', '    }\n', '\n', '    function awardPrizes(uint256 _seed) private {\n', '        uint32 winningNumber = rand(SIZE-1, _seed); // -1 since index starts at 0\n', '        bool jackpotWon = winningNumber == rand(JACKPOT_SIZE-1, _seed); // -1 since index starts at 0\n', '\n', '        // scope of participants\n', '        uint256 start = gameNumber.mul(SIZE);\n', '        uint256 end = start + SIZE;\n', '\n', '        uint256 winnerIndex = start.add(winningNumber);\n', '\n', '        for (uint8 i = 0; i < prizes.length; i++) {\n', '            \n', '            if (jackpotWon && i==0) { distributeJackpot(winnerIndex); }\n', '\n', '            if (winnerIndex+i > end) {\n', '              // to keep within the bounds of participants, wrap around\n', '                winnerIndex -= SIZE;\n', '            }\n', '\n', "            participants[winnerIndex+i].transfer(prizes[i]); // msg.sender pays the gas, he's refunded later\n", '            \n', '            PrizeAwarded(gameNumber,  participants[winnerIndex+i], prizes[i]);\n', '        }\n', '        \n', '        // Split the rest\n', '        jackpot = jackpot.add(245 finney);  // add to jackpot\n', '        wallet.transfer(245 finney);        // *cash register sound*\n', '        msg.sender.transfer(10 finney);     // repay gas to msg.sender TODO: check if price is right\n', '\n', '        gameNumber++;\n', '    }\n', '\n', '    function distributeJackpot(uint256 _winnerIndex) {\n', '        participants[_winnerIndex].transfer(jackpot);\n', '        JackpotAwarded(gameNumber,  participants[_winnerIndex], jackpot);\n', '        jackpot = 0; // later on in the code money will be added\n', '    }\n', '\n', '    function destroy() onlyOwner {\n', '        // Transfer Eth to owner and terminate contract\n', '        token.destroy();\n', '        selfdestruct(owner);\n', '  }\n', '\n', '    function changeWallet(address _newWallet) onlyOwner {\n', '        require(_newWallet != 0x0);\n', '        wallet = _newWallet;\n', '  }\n', '\n', '}']
