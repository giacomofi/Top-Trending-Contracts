['pragma solidity 0.4.23;\n', '/**\n', '* @notice Multiple Investment BNT TOKEN CONTRACT\n', '* @dev ERC-20 Token Standar Compliant\n', '*/\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/*\n', '    Owned contract interface\n', '*/\n', 'contract IOwned {\n', '    // this function isn&#39;t abstract since the compiler emits automatically generated getter functions as external\n', '    function owner() public view returns (address) {}\n', '\n', '    function transferOwnership(address _newOwner) public;\n', '    function acceptOwnership() public;\n', '}\n', '\n', '/*\n', '    Bancor Converter interface\n', '*/\n', 'contract IBancorConverter{\n', '\n', '    function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256);\n', '\tfunction quickConvert(address[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);\n', '\n', '}\n', '/*\n', '    Bancor Quick Converter interface\n', '*/\n', 'contract IBancorQuickConverter {\n', '    function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);\n', '    function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);\n', '    function convertForPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, uint256 _block, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) public payable returns (uint256);\n', '}\n', '\n', '/*\n', '    Bancor Gas tools interface\n', '*/\n', 'contract IBancorGasPriceLimit {\n', '    function gasPrice() public view returns (uint256) {}\n', '    function validateGasPrice(uint256) public view;\n', '}\n', '\n', '/*\n', '    EIP228 Token Converter interface\n', '*/\n', 'contract ITokenConverter {\n', '    function convertibleTokenCount() public view returns (uint16);\n', '    function convertibleToken(uint16 _tokenIndex) public view returns (address);\n', '    function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);\n', '    function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);\n', '    // deprecated, backward compatibility\n', '    function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);\n', '}\n', '\n', '/*\n', '    ERC20 Standard Token interface\n', '*/\n', 'contract IERC20Token {\n', '    // these functions aren&#39;t abstract since the compiler emits automatically generated getter functions as external\n', '    function name() public view returns (string) {}\n', '    function symbol() public view returns (string) {}\n', '    function decimals() public view returns (uint8) {}\n', '    function totalSupply() public view returns (uint256) {}\n', '    function balanceOf(address _owner) public view returns (uint256) { _owner; }\n', '    function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '/*\n', '    Smart Token interface\n', '*/\n', 'contract ISmartToken is IOwned, IERC20Token {\n', '    function disableTransfers(bool _disable) public;\n', '    function issue(address _to, uint256 _amount) public;\n', '    function destroy(address _from, uint256 _amount) public;\n', '}\n', '\n', '/**\n', '* @title Admin parameters\n', '* @dev Define administration parameters for this contract\n', '*/\n', 'contract admined { //This token contract is administered\n', '    address public admin; //Admin address is public\n', '\n', '    /**\n', '    * @dev Contract constructor\n', '    * define initial administrator\n', '    */\n', '    constructor() internal {\n', '        admin = msg.sender; //Set initial admin to contract creator\n', '        emit Admined(admin);\n', '    }\n', '\n', '    modifier onlyAdmin() { //A modifier to define admin-only functions\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '   /**\n', '    * @dev Function to set new admin address\n', '    * @param _newAdmin The address to transfer administration to\n', '    */\n', '    function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered\n', '        require(_newAdmin != 0);\n', '        admin = _newAdmin;\n', '        emit TransferAdminship(admin);\n', '    }\n', '\n', '    event TransferAdminship(address newAdminister);\n', '    event Admined(address administer);\n', '\n', '}\n', '\n', '\n', '/**\n', '* @title ERC20Token\n', '* @notice Token definition contract\n', '*/\n', 'contract MIB is admined,IERC20Token { //Standar definition of an ERC20Token\n', '    using SafeMath for uint256; //SafeMath is used for uint256 operations\n', '\n', '///////////////////////////////////////////////////////////////////////////////////////\n', '///\t\t\t\t\t\t\t\t\tToken Related\t\t\t\t\t\t\t\t\t///\n', '///////////////////////////////////////////////////////////////////////////////////////\n', '\n', '    mapping (address => uint256) balances; //A mapping of all balances per address\n', '    mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances\n', '    uint256 public totalSupply;\n', '    \n', '    /**\n', '    * @notice Get the balance of an _owner address.\n', '    * @param _owner The address to be query.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 bal) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @notice transfer _value tokens to address _to\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    * @return success with boolean value true if done\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0)); //If you dont want that people destroy token\n', '        \n', '        if(_to == address(this)){\n', '        \tsell(msg.sender,_value);\n', '        \treturn true;\n', '        } else {\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '\t        balances[_to] = balances[_to].add(_value);\n', '    \t    emit Transfer(msg.sender, _to, _value);\n', '        \treturn true;\n', '\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @notice Transfer _value tokens from address _from to address _to using allowance msg.sender allowance on _from\n', '    * @param _from The address where tokens comes.\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    * @return success with boolean value true if done\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0)); //If you dont want that people destroy token\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @notice Assign allowance _value to _spender address to use the msg.sender balance\n', '    * @param _spender The address to be allowed to spend.\n', '    * @param _value The amount to be allowed.\n', '    * @return success with boolean value true\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '    \trequire((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @notice Get the allowance of an specified address to use another address balance.\n', '    * @param _owner The address of the owner of the tokens.\n', '    * @param _spender The address of the allowed spender.\n', '    * @return remaining with the allowance value\n', '    */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Mint token to an specified address.\n', '    * @param _target The address of the receiver of the tokens.\n', '    * @param _mintedAmount amount to mint.\n', '    */\n', '    function mintToken(address _target, uint256 _mintedAmount) private {\n', '        balances[_target] = SafeMath.add(balances[_target], _mintedAmount);\n', '        totalSupply = SafeMath.add(totalSupply, _mintedAmount);\n', '        emit Transfer(0, this, _mintedAmount);\n', '        emit Transfer(this, _target, _mintedAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Burn token of an specified address.\n', '    * @param _target The address of the holder of the tokens.\n', '    * @param _burnedAmount amount to burn.\n', '    */\n', '    function burnToken(address _target, uint256 _burnedAmount) private {\n', '        balances[_target] = SafeMath.sub(balances[_target], _burnedAmount);\n', '        totalSupply = SafeMath.sub(totalSupply, _burnedAmount);\n', '        emit Burned(_target, _burnedAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Log Events\n', '    */\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burned(address indexed _target, uint256 _value);\n', '\n', '///////////////////////////////////////////////////////////////////////////////////////\n', '///\t\t\t\t\t\t\t\tInvestment related\t\t\t\t\t\t\t\t\t///\n', '///////////////////////////////////////////////////////////////////////////////////////\n', '\n', '\t//Internal Bancor Variables\n', '\tIBancorConverter BancorConverter = IBancorConverter(0xc6725aE749677f21E4d8f85F41cFB6DE49b9Db29);\n', '\tIBancorQuickConverter Bancor = IBancorQuickConverter(0xcF1CC6eD5B653DeF7417E3fA93992c3FFe49139B);\n', '\tIBancorGasPriceLimit BancorGas = IBancorGasPriceLimit(0x607a5C47978e2Eb6d59C6C6f51bc0bF411f4b85a);\n', '\t//ERC20 ETH token\n', '\tIERC20Token ETHToken = IERC20Token(0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315);\n', '\t//BNT token\n', '\tIERC20Token BNTToken = IERC20Token(0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C);\n', '\t//Flag for initial sale\n', '\tbool buyFlag = false; //False = set rate - True = auto rate\n', '\t//Relays initial list\n', '\tIERC20Token[8]\trelays = [\n', '\t\t\tIERC20Token(0x507b06c23d7Cb313194dBF6A6D80297137fb5E01),\n', '\t\t\tIERC20Token(0x0F2318565f1996CB1eD2F88e172135791BC1FcBf),\n', '\t\t\tIERC20Token(0x5a4deB5704C1891dF3575d3EecF9471DA7F61Fa4),\n', '\t\t\tIERC20Token(0x564c07255AFe5050D82c8816F78dA13f2B17ac6D),\n', '\t\t\tIERC20Token(0xa7774F9386E1653645E1A08fb7Aae525B4DeDb24),\n', '\t\t\tIERC20Token(0xd2Deb679ed81238CaeF8E0c32257092cEcc8888b),\n', '\t\t\tIERC20Token(0x67563E7A0F13642068F6F999e48c690107A4571F),\n', '\t\t\tIERC20Token(0x168D7Bbf38E17941173a352f1352DF91a7771dF3)\n', '\t\t];\n', '\t//Tokens initial list\n', '\tIERC20Token[8]\ttokens = [\n', '\t\t\tIERC20Token(0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0),\n', '\t\t\tIERC20Token(0xbf2179859fc6D5BEE9Bf9158632Dc51678a4100e),\n', '\t\t\tIERC20Token(0xA15C7Ebe1f07CaF6bFF097D8a589fb8AC49Ae5B3),\n', '\t\t\tIERC20Token(0x6758B7d441a9739b98552B373703d8d3d14f9e62),\n', '\t\t\tIERC20Token(0x419c4dB4B9e25d6Db2AD9691ccb832C8D9fDA05E),\n', '\t\t\tIERC20Token(0x68d57c9a1C35f63E2c83eE8e49A64e9d70528D25),\n', '\t\t\tIERC20Token(0x39Bb259F66E1C59d5ABEF88375979b4D20D98022),\n', '\t\t\tIERC20Token(0x595832F8FC6BF59c85C527fEC3740A1b7a361269)\n', '\t\t];\n', '\t//Path to exchanges\n', '\tmapping(uint8 => IERC20Token[]) paths;\n', '\tmapping(uint8 => IERC20Token[]) reversePaths;\n', '\t//public variables\n', '\taddress public feeWallet;\n', '\tuint256 public rate = 10000;\n', '\t//token related\n', '\tstring public name = "MULTIPLE INVEST BNT";\n', '    uint8 public decimals = 18;\n', '    string public symbol = "MIB";//Like Men In Black B)\n', '    string public version = &#39;1&#39;;\n', '\n', '\tconstructor(address _feeWallet) public {\n', '\t\tfeeWallet = _feeWallet;\n', '\n', '\t\tpaths[0] = [ETHToken,BNTToken,BNTToken,relays[0],relays[0],relays[0],tokens[0]];\n', '    \tpaths[1] = [ETHToken,BNTToken,BNTToken,relays[1],relays[1],relays[1],tokens[1]];\n', '    \tpaths[2] = [ETHToken,BNTToken,BNTToken,relays[2],relays[2],relays[2],tokens[2]];\n', '    \tpaths[3] = [ETHToken,BNTToken,BNTToken,relays[3],relays[3],relays[3],tokens[3]];\n', '    \tpaths[4] = [ETHToken,BNTToken,BNTToken,relays[4],relays[4],relays[4],tokens[4]];\n', '    \tpaths[5] = [ETHToken,BNTToken,BNTToken,relays[5],relays[5],relays[5],tokens[5]];\n', '    \tpaths[6] = [ETHToken,BNTToken,BNTToken,relays[6],relays[6],relays[6],tokens[6]];\n', '    \tpaths[7] = [ETHToken,BNTToken,BNTToken,relays[7],relays[7],relays[7],tokens[7]];\n', '\n', '    \treversePaths[0] = [tokens[0],relays[0],relays[0],relays[0],BNTToken,BNTToken,ETHToken];\n', '    \treversePaths[1] = [tokens[1],relays[1],relays[1],relays[1],BNTToken,BNTToken,ETHToken];\n', '    \treversePaths[2] = [tokens[2],relays[2],relays[2],relays[2],BNTToken,BNTToken,ETHToken];\n', '    \treversePaths[3] = [tokens[3],relays[3],relays[3],relays[3],BNTToken,BNTToken,ETHToken];\n', '    \treversePaths[4] = [tokens[4],relays[4],relays[4],relays[4],BNTToken,BNTToken,ETHToken];\n', '    \treversePaths[5] = [tokens[5],relays[5],relays[5],relays[5],BNTToken,BNTToken,ETHToken];\n', '    \treversePaths[6] = [tokens[6],relays[6],relays[6],relays[6],BNTToken,BNTToken,ETHToken];\n', '    \treversePaths[7] = [tokens[7],relays[7],relays[7],relays[7],BNTToken,BNTToken,ETHToken];\n', '\t}\n', '\n', '\tfunction viewTokenName(uint8 _index) public view returns(string){\n', '\t\treturn tokens[_index].name();\n', '\t}\n', '\n', '\tfunction viewMaxGasPrice() public view returns(uint256){\n', '\t\treturn BancorGas.gasPrice();\n', '\t}\n', '\n', '\tfunction updateBancorContracts(\n', '\t\tIBancorConverter _BancorConverter,\n', '\t\tIBancorQuickConverter _Bancor,\n', '\t\tIBancorGasPriceLimit _BancorGas) public onlyAdmin{\n', '\n', '\t\tBancorConverter = _BancorConverter;\n', '\t\tBancor = _Bancor;\n', '\t\tBancorGas = _BancorGas;\n', '\t}\n', '\n', '\tfunction valueOnContract() public view returns (uint256){\n', '\n', '\t\tISmartToken smartToken;\n', '        IERC20Token toToken;\n', '        ITokenConverter converter;\n', '        IERC20Token[] memory _path;\n', '        uint256 pathLength;\n', '        uint256 sumUp;\n', '        uint256 _amount;\n', '        IERC20Token _fromToken;\n', '\n', '        for(uint8 j=0;j<8;j++){\n', '        \t_path = reversePaths[j];\n', '        \t// iterate over the conversion path\n', '\t        pathLength = _path.length;\n', '\t        _fromToken = _path[0];\n', '\t        _amount = _fromToken.balanceOf(address(this));\n', '\n', '\t        for (uint256 i = 1; i < pathLength; i += 2) {\n', '\t            smartToken = ISmartToken(_path[i]);\n', '\t            toToken = _path[i + 1];\n', '\t            converter = ITokenConverter(smartToken.owner());\n', '\n', '\t            // make the conversion - if it&#39;s the last one, also provide the minimum return value\n', '\t            _amount = converter.getReturn(_fromToken, toToken, _amount);\n', '\t            _fromToken = toToken;\n', '\t        }\n', '\t        \n', '\t        sumUp += _amount;\n', '        }\n', '\n', '        return sumUp;\n', '\n', '\t}\n', '\n', '\tfunction buy() public payable {\n', '\t    BancorGas.validateGasPrice(tx.gasprice);\n', '\n', '\t    if(totalSupply >= 10000000*10**18){\n', '\t    \tbuyFlag = true;\n', '\t    }\n', '\n', '\t\tif(buyFlag == false){\n', '\t\t\ttokenBuy = msg.value.mul(rate);\n', '\t\t} else {\n', '\n', '\t\t\tuint256 valueStored = valueOnContract();\n', '\t\t\tuint256 tokenBuy;\n', '\n', '\t\t\tif(totalSupply > valueStored){\n', '\n', '\t\t\t\tuint256 tempRate = totalSupply.div(valueStored); // Must be > 0 Tok/Eth\n', '\t\t\t\ttokenBuy = msg.value.mul(tempRate); // Eth * Tok / Eth = Tok\n', '\n', '\t\t\t} else {\n', '\t\t\t\t\n', '\t\t\t\tuint256 tempPrice = valueStored.div(totalSupply); // Must be > 0 Eth/Tok\n', '\t\t\t\ttokenBuy = msg.value.div(tempPrice); // Eth / Eth / Tok = Tok\n', '\n', '\t\t\t}\n', '\t\t}\n', '\n', '\t\tuint256 ethFee = msg.value.mul(5);\n', '\t\tethFee = ethFee.div(1000); //5/1000 => 0.5%\n', '\t\tuint256 ethToInvest = msg.value.sub(ethFee);\n', '\t\t//tranfer fees\n', '\t\tfeeWallet.transfer(ethFee);\n', '\t\t//invest on tokens\n', '\t\tinvest(ethToInvest);\n', '\t\t//deliver your shares\n', '\t\tmintToken(msg.sender,tokenBuy);\n', '\n', '\t}\n', '\n', '\tfunction invest(uint256 _amount) private {\n', '\t\tuint256 standarValue = _amount.div(8); //evenly distributed eth on tokens\n', '\n', '\t\tfor(uint8 i=0; i<8; i++){ \n', '\t\t\tBancor.convertForPrioritized.value(standarValue)(paths[i],standarValue,1,address(this),0,0,0,0x0,0x0);\n', '\t\t}\n', '\n', '\t}\n', '\n', '\tfunction sell(address _target, uint256 _amount) private {\n', '\t\tuint256 tempBalance;\n', '\t\tuint256 tempFee;\n', '\t\tuint256 dividedSupply = totalSupply.div(1e5); //ethereum is not decimals friendly\n', '\n', '\t\tif(dividedSupply == 0 || _amount < dividedSupply) revert();\n', '\t\t\n', '\t\tuint256 factor = _amount.div(dividedSupply);\n', '\n', '\t\tif( factor == 0) revert();\n', '\n', '\t\tburnToken(_target, _amount);\n', '\t\t\n', '\t\tfor(uint8 i=0;i<8;i++){\n', '\t\t\ttempBalance = tokens[i].balanceOf(this);\n', '\t\t\ttempBalance = tempBalance.mul(factor);\n', '\t\t\ttempBalance = tempBalance.div(1e5);\n', '\t\t\ttempFee = tempBalance.mul(5);\n', '\t\t\ttempFee = tempFee.div(1000); //0.5%\n', '\t\t\ttempBalance = tempBalance.sub(tempFee);\n', '\n', '\t\t\ttokens[i].transfer(feeWallet,tempFee);\n', '\t\t\ttokens[i].transfer(_target,tempBalance);\n', '\t\t}\n', '\t\t\n', '\n', '\t}\n', '\t\n', '\tfunction () public payable{\n', '\t\tbuy();\n', '\t}\n', '\n', '}']
['pragma solidity 0.4.23;\n', '/**\n', '* @notice Multiple Investment BNT TOKEN CONTRACT\n', '* @dev ERC-20 Token Standar Compliant\n', '*/\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/*\n', '    Owned contract interface\n', '*/\n', 'contract IOwned {\n', "    // this function isn't abstract since the compiler emits automatically generated getter functions as external\n", '    function owner() public view returns (address) {}\n', '\n', '    function transferOwnership(address _newOwner) public;\n', '    function acceptOwnership() public;\n', '}\n', '\n', '/*\n', '    Bancor Converter interface\n', '*/\n', 'contract IBancorConverter{\n', '\n', '    function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256);\n', '\tfunction quickConvert(address[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);\n', '\n', '}\n', '/*\n', '    Bancor Quick Converter interface\n', '*/\n', 'contract IBancorQuickConverter {\n', '    function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);\n', '    function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);\n', '    function convertForPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, uint256 _block, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) public payable returns (uint256);\n', '}\n', '\n', '/*\n', '    Bancor Gas tools interface\n', '*/\n', 'contract IBancorGasPriceLimit {\n', '    function gasPrice() public view returns (uint256) {}\n', '    function validateGasPrice(uint256) public view;\n', '}\n', '\n', '/*\n', '    EIP228 Token Converter interface\n', '*/\n', 'contract ITokenConverter {\n', '    function convertibleTokenCount() public view returns (uint16);\n', '    function convertibleToken(uint16 _tokenIndex) public view returns (address);\n', '    function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);\n', '    function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);\n', '    // deprecated, backward compatibility\n', '    function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);\n', '}\n', '\n', '/*\n', '    ERC20 Standard Token interface\n', '*/\n', 'contract IERC20Token {\n', "    // these functions aren't abstract since the compiler emits automatically generated getter functions as external\n", '    function name() public view returns (string) {}\n', '    function symbol() public view returns (string) {}\n', '    function decimals() public view returns (uint8) {}\n', '    function totalSupply() public view returns (uint256) {}\n', '    function balanceOf(address _owner) public view returns (uint256) { _owner; }\n', '    function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '/*\n', '    Smart Token interface\n', '*/\n', 'contract ISmartToken is IOwned, IERC20Token {\n', '    function disableTransfers(bool _disable) public;\n', '    function issue(address _to, uint256 _amount) public;\n', '    function destroy(address _from, uint256 _amount) public;\n', '}\n', '\n', '/**\n', '* @title Admin parameters\n', '* @dev Define administration parameters for this contract\n', '*/\n', 'contract admined { //This token contract is administered\n', '    address public admin; //Admin address is public\n', '\n', '    /**\n', '    * @dev Contract constructor\n', '    * define initial administrator\n', '    */\n', '    constructor() internal {\n', '        admin = msg.sender; //Set initial admin to contract creator\n', '        emit Admined(admin);\n', '    }\n', '\n', '    modifier onlyAdmin() { //A modifier to define admin-only functions\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '   /**\n', '    * @dev Function to set new admin address\n', '    * @param _newAdmin The address to transfer administration to\n', '    */\n', '    function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered\n', '        require(_newAdmin != 0);\n', '        admin = _newAdmin;\n', '        emit TransferAdminship(admin);\n', '    }\n', '\n', '    event TransferAdminship(address newAdminister);\n', '    event Admined(address administer);\n', '\n', '}\n', '\n', '\n', '/**\n', '* @title ERC20Token\n', '* @notice Token definition contract\n', '*/\n', 'contract MIB is admined,IERC20Token { //Standar definition of an ERC20Token\n', '    using SafeMath for uint256; //SafeMath is used for uint256 operations\n', '\n', '///////////////////////////////////////////////////////////////////////////////////////\n', '///\t\t\t\t\t\t\t\t\tToken Related\t\t\t\t\t\t\t\t\t///\n', '///////////////////////////////////////////////////////////////////////////////////////\n', '\n', '    mapping (address => uint256) balances; //A mapping of all balances per address\n', '    mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances\n', '    uint256 public totalSupply;\n', '    \n', '    /**\n', '    * @notice Get the balance of an _owner address.\n', '    * @param _owner The address to be query.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 bal) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /**\n', '    * @notice transfer _value tokens to address _to\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    * @return success with boolean value true if done\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0)); //If you dont want that people destroy token\n', '        \n', '        if(_to == address(this)){\n', '        \tsell(msg.sender,_value);\n', '        \treturn true;\n', '        } else {\n', '            balances[msg.sender] = balances[msg.sender].sub(_value);\n', '\t        balances[_to] = balances[_to].add(_value);\n', '    \t    emit Transfer(msg.sender, _to, _value);\n', '        \treturn true;\n', '\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @notice Transfer _value tokens from address _from to address _to using allowance msg.sender allowance on _from\n', '    * @param _from The address where tokens comes.\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    * @return success with boolean value true if done\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0)); //If you dont want that people destroy token\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @notice Assign allowance _value to _spender address to use the msg.sender balance\n', '    * @param _spender The address to be allowed to spend.\n', '    * @param _value The amount to be allowed.\n', '    * @return success with boolean value true\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '    \trequire((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @notice Get the allowance of an specified address to use another address balance.\n', '    * @param _owner The address of the owner of the tokens.\n', '    * @param _spender The address of the allowed spender.\n', '    * @return remaining with the allowance value\n', '    */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /**\n', '    * @dev Mint token to an specified address.\n', '    * @param _target The address of the receiver of the tokens.\n', '    * @param _mintedAmount amount to mint.\n', '    */\n', '    function mintToken(address _target, uint256 _mintedAmount) private {\n', '        balances[_target] = SafeMath.add(balances[_target], _mintedAmount);\n', '        totalSupply = SafeMath.add(totalSupply, _mintedAmount);\n', '        emit Transfer(0, this, _mintedAmount);\n', '        emit Transfer(this, _target, _mintedAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Burn token of an specified address.\n', '    * @param _target The address of the holder of the tokens.\n', '    * @param _burnedAmount amount to burn.\n', '    */\n', '    function burnToken(address _target, uint256 _burnedAmount) private {\n', '        balances[_target] = SafeMath.sub(balances[_target], _burnedAmount);\n', '        totalSupply = SafeMath.sub(totalSupply, _burnedAmount);\n', '        emit Burned(_target, _burnedAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Log Events\n', '    */\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Burned(address indexed _target, uint256 _value);\n', '\n', '///////////////////////////////////////////////////////////////////////////////////////\n', '///\t\t\t\t\t\t\t\tInvestment related\t\t\t\t\t\t\t\t\t///\n', '///////////////////////////////////////////////////////////////////////////////////////\n', '\n', '\t//Internal Bancor Variables\n', '\tIBancorConverter BancorConverter = IBancorConverter(0xc6725aE749677f21E4d8f85F41cFB6DE49b9Db29);\n', '\tIBancorQuickConverter Bancor = IBancorQuickConverter(0xcF1CC6eD5B653DeF7417E3fA93992c3FFe49139B);\n', '\tIBancorGasPriceLimit BancorGas = IBancorGasPriceLimit(0x607a5C47978e2Eb6d59C6C6f51bc0bF411f4b85a);\n', '\t//ERC20 ETH token\n', '\tIERC20Token ETHToken = IERC20Token(0xc0829421C1d260BD3cB3E0F06cfE2D52db2cE315);\n', '\t//BNT token\n', '\tIERC20Token BNTToken = IERC20Token(0x1F573D6Fb3F13d689FF844B4cE37794d79a7FF1C);\n', '\t//Flag for initial sale\n', '\tbool buyFlag = false; //False = set rate - True = auto rate\n', '\t//Relays initial list\n', '\tIERC20Token[8]\trelays = [\n', '\t\t\tIERC20Token(0x507b06c23d7Cb313194dBF6A6D80297137fb5E01),\n', '\t\t\tIERC20Token(0x0F2318565f1996CB1eD2F88e172135791BC1FcBf),\n', '\t\t\tIERC20Token(0x5a4deB5704C1891dF3575d3EecF9471DA7F61Fa4),\n', '\t\t\tIERC20Token(0x564c07255AFe5050D82c8816F78dA13f2B17ac6D),\n', '\t\t\tIERC20Token(0xa7774F9386E1653645E1A08fb7Aae525B4DeDb24),\n', '\t\t\tIERC20Token(0xd2Deb679ed81238CaeF8E0c32257092cEcc8888b),\n', '\t\t\tIERC20Token(0x67563E7A0F13642068F6F999e48c690107A4571F),\n', '\t\t\tIERC20Token(0x168D7Bbf38E17941173a352f1352DF91a7771dF3)\n', '\t\t];\n', '\t//Tokens initial list\n', '\tIERC20Token[8]\ttokens = [\n', '\t\t\tIERC20Token(0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0),\n', '\t\t\tIERC20Token(0xbf2179859fc6D5BEE9Bf9158632Dc51678a4100e),\n', '\t\t\tIERC20Token(0xA15C7Ebe1f07CaF6bFF097D8a589fb8AC49Ae5B3),\n', '\t\t\tIERC20Token(0x6758B7d441a9739b98552B373703d8d3d14f9e62),\n', '\t\t\tIERC20Token(0x419c4dB4B9e25d6Db2AD9691ccb832C8D9fDA05E),\n', '\t\t\tIERC20Token(0x68d57c9a1C35f63E2c83eE8e49A64e9d70528D25),\n', '\t\t\tIERC20Token(0x39Bb259F66E1C59d5ABEF88375979b4D20D98022),\n', '\t\t\tIERC20Token(0x595832F8FC6BF59c85C527fEC3740A1b7a361269)\n', '\t\t];\n', '\t//Path to exchanges\n', '\tmapping(uint8 => IERC20Token[]) paths;\n', '\tmapping(uint8 => IERC20Token[]) reversePaths;\n', '\t//public variables\n', '\taddress public feeWallet;\n', '\tuint256 public rate = 10000;\n', '\t//token related\n', '\tstring public name = "MULTIPLE INVEST BNT";\n', '    uint8 public decimals = 18;\n', '    string public symbol = "MIB";//Like Men In Black B)\n', "    string public version = '1';\n", '\n', '\tconstructor(address _feeWallet) public {\n', '\t\tfeeWallet = _feeWallet;\n', '\n', '\t\tpaths[0] = [ETHToken,BNTToken,BNTToken,relays[0],relays[0],relays[0],tokens[0]];\n', '    \tpaths[1] = [ETHToken,BNTToken,BNTToken,relays[1],relays[1],relays[1],tokens[1]];\n', '    \tpaths[2] = [ETHToken,BNTToken,BNTToken,relays[2],relays[2],relays[2],tokens[2]];\n', '    \tpaths[3] = [ETHToken,BNTToken,BNTToken,relays[3],relays[3],relays[3],tokens[3]];\n', '    \tpaths[4] = [ETHToken,BNTToken,BNTToken,relays[4],relays[4],relays[4],tokens[4]];\n', '    \tpaths[5] = [ETHToken,BNTToken,BNTToken,relays[5],relays[5],relays[5],tokens[5]];\n', '    \tpaths[6] = [ETHToken,BNTToken,BNTToken,relays[6],relays[6],relays[6],tokens[6]];\n', '    \tpaths[7] = [ETHToken,BNTToken,BNTToken,relays[7],relays[7],relays[7],tokens[7]];\n', '\n', '    \treversePaths[0] = [tokens[0],relays[0],relays[0],relays[0],BNTToken,BNTToken,ETHToken];\n', '    \treversePaths[1] = [tokens[1],relays[1],relays[1],relays[1],BNTToken,BNTToken,ETHToken];\n', '    \treversePaths[2] = [tokens[2],relays[2],relays[2],relays[2],BNTToken,BNTToken,ETHToken];\n', '    \treversePaths[3] = [tokens[3],relays[3],relays[3],relays[3],BNTToken,BNTToken,ETHToken];\n', '    \treversePaths[4] = [tokens[4],relays[4],relays[4],relays[4],BNTToken,BNTToken,ETHToken];\n', '    \treversePaths[5] = [tokens[5],relays[5],relays[5],relays[5],BNTToken,BNTToken,ETHToken];\n', '    \treversePaths[6] = [tokens[6],relays[6],relays[6],relays[6],BNTToken,BNTToken,ETHToken];\n', '    \treversePaths[7] = [tokens[7],relays[7],relays[7],relays[7],BNTToken,BNTToken,ETHToken];\n', '\t}\n', '\n', '\tfunction viewTokenName(uint8 _index) public view returns(string){\n', '\t\treturn tokens[_index].name();\n', '\t}\n', '\n', '\tfunction viewMaxGasPrice() public view returns(uint256){\n', '\t\treturn BancorGas.gasPrice();\n', '\t}\n', '\n', '\tfunction updateBancorContracts(\n', '\t\tIBancorConverter _BancorConverter,\n', '\t\tIBancorQuickConverter _Bancor,\n', '\t\tIBancorGasPriceLimit _BancorGas) public onlyAdmin{\n', '\n', '\t\tBancorConverter = _BancorConverter;\n', '\t\tBancor = _Bancor;\n', '\t\tBancorGas = _BancorGas;\n', '\t}\n', '\n', '\tfunction valueOnContract() public view returns (uint256){\n', '\n', '\t\tISmartToken smartToken;\n', '        IERC20Token toToken;\n', '        ITokenConverter converter;\n', '        IERC20Token[] memory _path;\n', '        uint256 pathLength;\n', '        uint256 sumUp;\n', '        uint256 _amount;\n', '        IERC20Token _fromToken;\n', '\n', '        for(uint8 j=0;j<8;j++){\n', '        \t_path = reversePaths[j];\n', '        \t// iterate over the conversion path\n', '\t        pathLength = _path.length;\n', '\t        _fromToken = _path[0];\n', '\t        _amount = _fromToken.balanceOf(address(this));\n', '\n', '\t        for (uint256 i = 1; i < pathLength; i += 2) {\n', '\t            smartToken = ISmartToken(_path[i]);\n', '\t            toToken = _path[i + 1];\n', '\t            converter = ITokenConverter(smartToken.owner());\n', '\n', "\t            // make the conversion - if it's the last one, also provide the minimum return value\n", '\t            _amount = converter.getReturn(_fromToken, toToken, _amount);\n', '\t            _fromToken = toToken;\n', '\t        }\n', '\t        \n', '\t        sumUp += _amount;\n', '        }\n', '\n', '        return sumUp;\n', '\n', '\t}\n', '\n', '\tfunction buy() public payable {\n', '\t    BancorGas.validateGasPrice(tx.gasprice);\n', '\n', '\t    if(totalSupply >= 10000000*10**18){\n', '\t    \tbuyFlag = true;\n', '\t    }\n', '\n', '\t\tif(buyFlag == false){\n', '\t\t\ttokenBuy = msg.value.mul(rate);\n', '\t\t} else {\n', '\n', '\t\t\tuint256 valueStored = valueOnContract();\n', '\t\t\tuint256 tokenBuy;\n', '\n', '\t\t\tif(totalSupply > valueStored){\n', '\n', '\t\t\t\tuint256 tempRate = totalSupply.div(valueStored); // Must be > 0 Tok/Eth\n', '\t\t\t\ttokenBuy = msg.value.mul(tempRate); // Eth * Tok / Eth = Tok\n', '\n', '\t\t\t} else {\n', '\t\t\t\t\n', '\t\t\t\tuint256 tempPrice = valueStored.div(totalSupply); // Must be > 0 Eth/Tok\n', '\t\t\t\ttokenBuy = msg.value.div(tempPrice); // Eth / Eth / Tok = Tok\n', '\n', '\t\t\t}\n', '\t\t}\n', '\n', '\t\tuint256 ethFee = msg.value.mul(5);\n', '\t\tethFee = ethFee.div(1000); //5/1000 => 0.5%\n', '\t\tuint256 ethToInvest = msg.value.sub(ethFee);\n', '\t\t//tranfer fees\n', '\t\tfeeWallet.transfer(ethFee);\n', '\t\t//invest on tokens\n', '\t\tinvest(ethToInvest);\n', '\t\t//deliver your shares\n', '\t\tmintToken(msg.sender,tokenBuy);\n', '\n', '\t}\n', '\n', '\tfunction invest(uint256 _amount) private {\n', '\t\tuint256 standarValue = _amount.div(8); //evenly distributed eth on tokens\n', '\n', '\t\tfor(uint8 i=0; i<8; i++){ \n', '\t\t\tBancor.convertForPrioritized.value(standarValue)(paths[i],standarValue,1,address(this),0,0,0,0x0,0x0);\n', '\t\t}\n', '\n', '\t}\n', '\n', '\tfunction sell(address _target, uint256 _amount) private {\n', '\t\tuint256 tempBalance;\n', '\t\tuint256 tempFee;\n', '\t\tuint256 dividedSupply = totalSupply.div(1e5); //ethereum is not decimals friendly\n', '\n', '\t\tif(dividedSupply == 0 || _amount < dividedSupply) revert();\n', '\t\t\n', '\t\tuint256 factor = _amount.div(dividedSupply);\n', '\n', '\t\tif( factor == 0) revert();\n', '\n', '\t\tburnToken(_target, _amount);\n', '\t\t\n', '\t\tfor(uint8 i=0;i<8;i++){\n', '\t\t\ttempBalance = tokens[i].balanceOf(this);\n', '\t\t\ttempBalance = tempBalance.mul(factor);\n', '\t\t\ttempBalance = tempBalance.div(1e5);\n', '\t\t\ttempFee = tempBalance.mul(5);\n', '\t\t\ttempFee = tempFee.div(1000); //0.5%\n', '\t\t\ttempBalance = tempBalance.sub(tempFee);\n', '\n', '\t\t\ttokens[i].transfer(feeWallet,tempFee);\n', '\t\t\ttokens[i].transfer(_target,tempBalance);\n', '\t\t}\n', '\t\t\n', '\n', '\t}\n', '\t\n', '\tfunction () public payable{\n', '\t\tbuy();\n', '\t}\n', '\n', '}']
