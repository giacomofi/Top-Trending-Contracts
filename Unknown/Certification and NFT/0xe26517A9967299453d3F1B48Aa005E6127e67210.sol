['pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'library SafeMath {\n', '  function mul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '\n', '/////////////////////////////////////////////////////////////////////////////\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Basic {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function transfer(address to, uint value);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '}\n', '\n', '\n', '////////////////////////////////////////////////\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '  function transferFrom(address from, address to, uint value);\n', '  function approve(address spender, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '///////////////////////////////////////////////\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint;\n', '\n', '  mapping(address => uint) balances;\n', '\n', '  /**\n', '   * @dev Fix for the ERC20 short address attack.\n', '   */\n', '  modifier onlyPayloadSize(uint size) {\n', '     if(msg.data.length < size + 4) {\n', '       throw;\n', '     }\n', '     _;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of. \n', '  * @return An uint representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '////////////////////////////////////////////////\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implemantation of the basic standart token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is BasicToken, ERC20 {\n', '\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint the amout of tokens to be transfered\n', '   */\n', '  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {\n', '    var _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // if (_value > _allowance) throw;\n', '\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint _value) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens than an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint specifing the amount of tokens still avaible for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '}\n', '\n', '\n', '///////////////////////////////////////////////////////////////////////////////////////////////////\n', '\n', '\n', '\n', '\n', 'contract NIMFAToken is StandardToken {\n', '\tusing SafeMath for uint256;\n', '\t\n', '\t\n', '\t\n', '\tevent CreatedNIMFA(address indexed _creator, uint256 _amountOfNIMFA);\n', '\t\n', '\t// Token data\n', '\tstring public constant name = "NIMFA Token";\n', '\tstring public constant symbol = "NIMFA";\n', '\tuint256 public constant decimals = 18; \n', '\tstring public version = "1.0";\n', '\t\n', '\t// Addresses and contracts\n', '\taddress public executor;\n', '\taddress public teamETHAddress;  \n', '\taddress public teamNIMFAAddress;\n', '\taddress public creditFundNIMFAAddress;\n', '\taddress public reserveNIMFAAddress;\n', '\t\n', '\tbool public preSaleHasEnded;\n', '\tbool public saleHasEnded;\n', '\tbool public allowTransfer;\n', '\tbool public maxPreSale;  // 1000000 NIMFA for pre sale price\n', '\tmapping (address => uint256) public ETHContributed;\n', '\tuint256 public totalETH;\n', '\tuint256 public preSaleStartBlock;\n', '\tuint256 public preSaleEndBlock;\n', '\tuint256 public saleStartBlock;\n', '\tuint256 public saleEndBlock;\n', '\tuint256 public constant NIMFA_PER_ETH_PRE_SALE = 1100;  // 1100 NIMFA = 1 ETH \n', '\tuint256 public constant NIMFA_PER_ETH_SALE = 110;  // 110 NIMFA = 1 ETH \n', '\t\n', '\n', '\t\n', '\tfunction NIMFAToken(\n', '\t\taddress _teamETHAddress,\n', '\t\taddress _teamNIMFAAddress,\n', '\t\taddress _creditFundNIMFAAddress,\n', '\t\taddress _reserveNIMFAAddress,\n', '\t\tuint256 _preSaleStartBlock,\n', '\t\tuint256 _preSaleEndBlock\n', '\t) {\n', '\t\t\n', '\t\tif (_teamETHAddress == address(0x0)) throw;\n', '\t\tif (_teamNIMFAAddress == address(0x0)) throw;\n', '\t\tif (_creditFundNIMFAAddress == address(0x0)) throw;\n', '\t\tif (_reserveNIMFAAddress == address(0x0)) throw;\n', '\t\t// Reject if sale ends before the current block\n', '\t\tif (_preSaleEndBlock <= block.number) throw;\n', '\t\t// Reject if the sale end time is less than the sale start time\n', '\t\tif (_preSaleEndBlock <= _preSaleStartBlock) throw;\n', '\n', '\t\texecutor = msg.sender;\n', '\t\tpreSaleHasEnded = false;\n', '\t\tsaleHasEnded = false;\n', '\t\tallowTransfer = false;\n', '\t\tmaxPreSale = false;\n', '\t\tteamETHAddress = _teamETHAddress;\n', '\t\tteamNIMFAAddress = _teamNIMFAAddress;\n', '\t\tcreditFundNIMFAAddress = _creditFundNIMFAAddress;\n', '\t\treserveNIMFAAddress = _reserveNIMFAAddress;\n', '\t\ttotalETH = 0;\n', '\t\tpreSaleStartBlock = _preSaleStartBlock;\n', '\t\tpreSaleEndBlock = _preSaleEndBlock;\n', '\t\tsaleStartBlock = _preSaleStartBlock;\n', '\t\tsaleEndBlock = _preSaleEndBlock;\n', '\t\ttotalSupply = 0;\n', '\t}\n', '\t\n', '\tfunction investment() payable external {\n', '\t\t// If preSale/Sale is not active, do not create NIMFA\n', '\t\tif (preSaleHasEnded && saleHasEnded) throw;\n', '\t\tif (!preSaleHasEnded) {\n', '\t\t    if (block.number < preSaleStartBlock) throw;\n', '\t\t    if (block.number > preSaleEndBlock) throw;\n', '\t\t}\n', '\t\tif (block.number < saleStartBlock) throw;\n', '\t\tif (block.number > saleEndBlock) throw;\n', '\t\t\n', '\t\tuint256 newEtherBalance = totalETH.add(msg.value);\n', '\n', '\t\t// Do not do anything if the amount of ether sent is 0\n', '\t\tif (0 == msg.value) throw;\n', '\t\t\n', '\t\t// Calculate the amount of NIMFA being purchased\n', '\t\tuint256 amountOfNIMFA = msg.value.mul(NIMFA_PER_ETH_PRE_SALE);\n', '\t\tif (preSaleHasEnded || maxPreSale) amountOfNIMFA = msg.value.mul(NIMFA_PER_ETH_SALE);\n', '\t\t\n', '\t\tif (100000 ether < amountOfNIMFA) throw;\n', '\t\t\n', '\t\t// Ensure that the transaction is safe\n', '\t\tuint256 totalSupplySafe = totalSupply.add(amountOfNIMFA);\n', '\t\tuint256 balanceSafe = balances[msg.sender].add(amountOfNIMFA);\n', '\t\tuint256 contributedSafe = ETHContributed[msg.sender].add(msg.value);\n', '\n', '\t\t// Update balances\n', '\t\ttotalSupply = totalSupplySafe;\n', '\t\tif (totalSupply > 2000000 ether) maxPreSale = true;\n', '\t\tbalances[msg.sender] = balanceSafe;\n', '\n', '\t\ttotalETH = newEtherBalance;\n', '\t\tETHContributed[msg.sender] = contributedSafe;\n', '\t\tif (!preSaleHasEnded) teamETHAddress.transfer(msg.value);\n', '\n', '\t\tCreatedNIMFA(msg.sender, amountOfNIMFA);\n', '\t}\n', '\t\n', '\tfunction endPreSale() {\n', '\t\t// Do not end an already ended sale\n', '\t\tif (preSaleHasEnded) throw;\n', '\t\t\n', '\t\t// Only allow the owner\n', '\t\tif (msg.sender != executor) throw;\n', '\t\t\n', '\t\tpreSaleHasEnded = true;\n', '\t}\n', '\t\n', '\t\n', '\tfunction endSale() {\n', '\t\t\n', '\t\tif (!preSaleHasEnded) throw;\n', '\t\t// Do not end an already ended sale\n', '\t\tif (saleHasEnded) throw;\n', '\t\t\n', '\t\t// Only allow the owner\n', '\t\tif (msg.sender != executor) throw;\n', '\t\t\n', '\t\tsaleHasEnded = true;\n', '\t\tuint256 EtherAmount = this.balance;\n', '\t\tteamETHAddress.transfer(EtherAmount);\n', '\t\t\n', '\t\tuint256 creditFund = totalSupply.mul(3);\n', '\t\tuint256 reserveNIMFA = totalSupply.div(2);\n', '\t\tuint256 teamNIMFA = totalSupply.div(2);\n', '\t\tuint256 totalSupplySafe = totalSupply.add(creditFund).add(reserveNIMFA).add(teamNIMFA);\n', '\n', '\n', '\t\ttotalSupply = totalSupplySafe;\n', '\t\tbalances[creditFundNIMFAAddress] = creditFund;\n', '\t\tbalances[reserveNIMFAAddress] = reserveNIMFA;\n', '\t\tbalances[teamNIMFAAddress] = teamNIMFA;\n', '\t\t\n', '\t\tCreatedNIMFA(creditFundNIMFAAddress, creditFund);\n', '\t\tCreatedNIMFA(reserveNIMFAAddress, reserveNIMFA);\n', '        CreatedNIMFA(teamNIMFAAddress, teamNIMFA);\n', '\t}\n', '\t\n', '\t\n', '\tfunction changeTeamETHAddress(address _newAddress) {\n', '\t\tif (msg.sender != executor) throw;\n', '\t\tteamETHAddress = _newAddress;\n', '\t}\n', '\t\n', '\tfunction changeTeamNIMFAAddress(address _newAddress) {\n', '\t\tif (msg.sender != executor) throw;\n', '\t\tteamNIMFAAddress = _newAddress;\n', '\t}\n', '\t\n', '\tfunction changeCreditFundNIMFAAddress(address _newAddress) {\n', '\t\tif (msg.sender != executor) throw;\n', '\t\tcreditFundNIMFAAddress = _newAddress;\n', '\t}\n', '\t\n', '\t/*\n', '\t* Allow transfer only after sales\n', '\t*/\n', '\tfunction changeAllowTransfer() {\n', '\t\tif (msg.sender != executor) throw;\n', '\n', '\t\tallowTransfer = true;\n', '\t}\n', '\t\n', '\t/*\n', '\t* \n', '\t*/\n', '\tfunction changeSaleStartBlock(uint256 _saleStartBlock) {\n', '\t\tif (msg.sender != executor) throw;\n', '        saleStartBlock = _saleStartBlock;\n', '\t}\n', '\t\n', '\t/*\n', '\t* \n', '\t*/\n', '\tfunction changeSaleEndBlock(uint256 _saleEndBlock) {\n', '\t\tif (msg.sender != executor) throw;\n', '        saleEndBlock = _saleEndBlock;\n', '\t}\n', '\t\n', '\t\n', '\tfunction transfer(address _to, uint _value) {\n', '\t\t// Cannot transfer unless the minimum cap is hit\n', '\t\tif (!allowTransfer) throw;\n', '\t\t\n', '\t\tsuper.transfer(_to, _value);\n', '\t}\n', '\t\n', '\tfunction transferFrom(address _from, address _to, uint _value) {\n', '\t\t// Cannot transfer unless the minimum cap is hit\n', '\t\tif (!allowTransfer) throw;\n', '\t\t\n', '\t\tsuper.transferFrom(_from, _to, _value);\n', '\t}\n', '}']