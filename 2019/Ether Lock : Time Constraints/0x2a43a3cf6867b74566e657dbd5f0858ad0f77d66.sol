['pragma solidity ^0.4.24;\n', '\n', '//\n', "//                       .#########'\n", '//                    .###############+\n', '//                  ,####################\n', '//                `#######################+\n', '//               ;##########################\n', '//              #############################.\n', '//             ###############################,\n', '//           +##################,    ###########`\n', '//          .###################     .###########\n', '//         ##############,          .###########+\n', '//         #############`            .############`\n', '//         ###########+                ############\n', '//        ###########;                  ###########\n', "//        ##########'                    ###########                                                                                      \n", "//       '##########    '#.        `,     ##########                                                                                    \n", "//       ##########    ####'      ####.   :#########;                                                                                   \n", "//      `#########'   :#####;    ######    ##########                                                                                 \n", '//      :#########    #######:  #######    :#########         \n', '//      +#########    :#######.########     #########`       \n', "//      #########;     ###############'     #########:       \n", "//      #########       #############+      '########'        \n", '//      #########        ############       :#########        \n', '//      #########         ##########        ,#########        \n', '//      #########         :########         ,#########        \n', '//      #########        ,##########        ,#########        \n', '//      #########       ,############       :########+        \n', "//      #########      .#############+      '########'        \n", "//      #########:    `###############'     #########,        \n", '//      +########+    ;#######`;#######     #########         \n', "//      ,#########    '######`  '######    :#########         \n", "//       #########;   .#####`    '#####    ##########         \n", "//       ##########    '###`      +###    :#########:         \n", '//       ;#########+     `                ##########          \n', '//        ##########,                    ###########          \n', '//         ###########;                ############\n', '//         +############             .############`\n', '//          ###########+           ,#############;\n', '//          `###########     ;++#################\n', '//           :##########,    ###################\n', "//            '###########.'###################\n", '//             +##############################\n', "//              '############################`\n", '//               .##########################\n', '//                 #######################:\n', '//                   ###################+\n', '//                     +##############:\n', '//                        :#######+`\n', '//\n', '//\n', '//\n', '// Play0x.com (The ONLY gaming platform for all ERC20 Tokens)\n', '// -------------------------------------------------------------------------------------------------------\n', '// * Multiple types of game platforms\n', '// * Build your own game zone - Not only playing games, but also allowing other players to join your game.\n', '// * Support all ERC20 tokens.\n', '//\n', '//\n', '//\n', '// 0xC Token (Contract address : 0x2a43a3cf6867b74566e657dbd5f0858ad0f77d66)\n', '// -------------------------------------------------------------------------------------------------------\n', '// * 0xC Token is an ERC20 Token specifically for digital entertainment.\n', '// * No ICO and private sales,fair access.\n', '// * There will be hundreds of games using 0xC as a game token.\n', "// * Token holders can permanently get ETH's profit sharing.\n", '//\n', '\n', '\n', '/**\n', '* @title SafeMath\n', '* @dev Math operations with safety checks that throw on error\n', '*/\n', 'library SafeMath {\n', '/**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '/**\n', '* @title Ownable\n', '* @dev The Ownable contract has an owner address, and provides basic authorization control \n', '* functions, this simplifies the implementation of "user permissions". \n', '*/ \n', 'contract Ownable {\n', '    address public owner;\n', '\n', '/** \n', '* @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '* account.\n', '*/\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', '* @title Standard ERC20 token\n', '*\n', '* @dev Implementation of the basic standard token.\n', '* @dev https://github.com/ethereum/EIPs/issues/20\n', '* @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', '*/\n', 'contract StandardToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    using SafeMath for uint256;\n', '    uint256 public totalSupply;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    mapping(address => uint256) balances;\n', '    \n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(balances[msg.sender] >= _value && balances[_to].add(_value) >= balances[_to]);\n', '\n', '    \n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of. \n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '    \n', '    /**\n', '    * @dev Transfer tokens from one address to another\n', '    * @param _from address The address which you want to send tokens from\n', '    * @param _to address The address which you want to transfer to\n', '    * @param _value uint256 the amout of tokens to be transfered\n', '    */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '    \n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }       \n', '\n', '    /**\n', '    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '    * @param _spender The address which will spend the funds.\n', '    * @param _value The amount of tokens to be spent.\n', '    */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    * @param _owner address The address which owns the funds.\n', '    * @param _spender address The address which will spend the funds.\n', '    * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '    */\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', '/*Token  Contract*/\n', 'contract Token0xC is StandardToken, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // Token Information\n', '    string  public constant name = "0xC";\n', '    string  public constant symbol = "0xC";\n', '    uint8   public constant decimals = 18;\n', '\n', '    // Sale period1.\n', '    uint256 public startDate1;\n', '    uint256 public endDate1;\n', '    uint256 public rate1;\n', '    \n', '    // Sale period2.\n', '    uint256 public startDate2;\n', '    uint256 public endDate2;\n', '    uint256 public rate2;\n', '    \n', '    // Sale period3. \n', '    uint256 public startDate3;\n', '    uint256 public endDate3;\n', '    uint256 public rate3;\n', '\n', '    //2018 08 16\n', '    uint256 BaseTimestamp = 1534377600;\n', '    \n', '    //SaleCap\n', '    uint256 public dailyCap;\n', '    uint256 public saleCap;\n', '    uint256 public LastbetDay;\n', '    uint256 public LeftDailyCap;\n', '    uint256 public BuyEtherLimit = 500000000000000000; //0.5 ether\n', '\n', '    // Address Where Token are keep\n', '    address public tokenWallet ;\n', '\n', '    // Address where funds are collected.\n', '    address public fundWallet ;\n', '\n', '    // Event\n', '    event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);\n', '    event TransferToken(address indexed buyer, uint256 amount);\n', '\n', '    // Modifiers\n', '    modifier uninitialized() {\n', '        require(tokenWallet == 0x0);\n', '        require(fundWallet == 0x0);\n', '        _;\n', '    }\n', '\n', '    constructor() public {}\n', '    // Trigger with Transfer event\n', '    // Fallback function can be used to buy tokens\n', '    function () public payable {\n', '        buyTokens(msg.sender, msg.value);\n', '    }\n', '\n', '    //Initial Contract\n', '    function initialize(address _tokenWallet, address _fundWallet, uint256 _start1, uint256 _end1,\n', '                         uint256 _dailyCap, uint256 _saleCap, uint256 _totalSupply) public\n', '                        onlyOwner uninitialized {\n', '        require(_start1 < _end1);\n', '        require(_tokenWallet != 0x0);\n', '        require(_fundWallet != 0x0);\n', '        require(_totalSupply >= _saleCap);\n', '\n', '        startDate1 = _start1;\n', '        endDate1 = _end1;\n', '        saleCap = _saleCap;\n', '        dailyCap = _dailyCap;\n', '        tokenWallet = _tokenWallet;\n', '        fundWallet = _fundWallet;\n', '        totalSupply = _totalSupply;\n', '\n', '        balances[tokenWallet] = saleCap;\n', '        balances[0xb1] = _totalSupply.sub(saleCap);\n', '    }\n', '\n', '    //Set Sale Period\n', '    function setPeriod(uint256 period, uint256 _start, uint256 _end) public onlyOwner {\n', '        require(_end > _start);\n', '        if (period == 1) {\n', '            startDate1 = _start;\n', '            endDate1 = _end;\n', '        }else if (period == 2) {\n', '            require(_start > endDate1);\n', '            startDate2 = _start;\n', '            endDate2 = _end;\n', '        }else if (period == 3) {\n', '            require(_start > endDate2);\n', '            startDate3 = _start;\n', '            endDate3 = _end;      \n', '        }\n', '    }\n', '\n', '    //Set Sale Period\n', '    function setPeriodRate(uint256 _period, uint256 _rate) public onlyOwner {\n', '        if (_period == 1) {\n', '           rate1 = _rate;\n', '        }else if (_period == 2) {\n', '            rate2 = _rate;\n', '        }else if (_period == 3) {\n', '            rate3 = _rate;\n', '        }\n', '    }\n', '\n', '    // For transferToken\n', '    function transferToken(address _to, uint256 amount) public onlyOwner {\n', "        require(saleCap >= amount,' Not Enough' );\n", '        require(_to != address(0));\n', '        require(_to != tokenWallet);\n', '        require(amount <= balances[tokenWallet]);\n', '\n', '        saleCap = saleCap.sub(amount);\n', '        // Transfer\n', '        balances[tokenWallet] = balances[tokenWallet].sub(amount);\n', '        balances[_to] = balances[_to].add(amount);\n', '        emit TransferToken(_to, amount);\n', '        emit Transfer(tokenWallet, _to, amount);\n', '    }\n', '\n', '    function setDailyCap(uint256 _dailyCap) public onlyOwner{\n', '        dailyCap = _dailyCap;\n', '    }\n', '    \n', '    function setBuyLimit(uint256 _BuyEtherLimit) public onlyOwner{\n', '        BuyEtherLimit = _BuyEtherLimit;\n', '    }\n', '\n', '    //Set SaleCap\n', '    function setSaleCap(uint256 _saleCap) public onlyOwner {\n', '        require(balances[0xb1].add(balances[tokenWallet]).sub(_saleCap) >= 0);\n', '        uint256 amount = 0;\n', '        //Check SaleCap\n', '        if (balances[tokenWallet] > _saleCap) {\n', '            amount = balances[tokenWallet].sub(_saleCap);\n', '            balances[0xb1] = balances[0xb1].add(amount);\n', '        } else {\n', '            amount = _saleCap.sub(balances[tokenWallet]);\n', '            balances[0xb1] = balances[0xb1].sub(amount);\n', '        }\n', '        balances[tokenWallet] = _saleCap;\n', '        saleCap = _saleCap;\n', '    }\n', '\n', '    //Calcute Bouns\n', '    function getBonusByTime() public constant returns (uint256) {\n', '        if (now < startDate1) {\n', '            return 0;\n', '        } else if (endDate1 > now && now > startDate1) {\n', '            return rate1;\n', '        } else if (endDate2 > now && now > startDate2) {\n', '            return rate2;\n', '        } else if (endDate3 > now && now > startDate3) {\n', '            return rate3;\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    //Stop Contract\n', '    function finalize() public onlyOwner {\n', '        require(!saleActive());\n', '\n', '        // Transfer the rest of token to tokenWallet\n', '        balances[tokenWallet] = balances[tokenWallet].add(balances[0xb1]);\n', '        balances[0xb1] = 0;\n', '    }\n', '    \n', '    //Purge the time in the timestamp.\n', '    function DateConverter(uint256 ts) public view returns(uint256 currentDayWithoutTime){\n', '        uint256 dayInterval = ts.sub(BaseTimestamp);\n', '        uint256 dayCount = dayInterval.div(86400);\n', '        return BaseTimestamp.add(dayCount.mul(86400));\n', '    }\n', '    \n', '    //Check SaleActive\n', '    function saleActive() public constant returns (bool) {\n', '        return (\n', '            (now >= startDate1 &&\n', '                now < endDate1 && saleCap > 0) ||\n', '            (now >= startDate2 &&\n', '                now < endDate2 && saleCap > 0) ||\n', '            (now >= startDate3 &&\n', '                now < endDate3 && saleCap > 0)\n', '                );\n', '    }\n', '    \n', '    //Buy Token\n', '    function buyTokens(address sender, uint256 value) internal {\n', '        //Check Sale Status\n', '        require(saleActive());\n', '        \n', '        //Minum buying limit\n', '        require(value >= BuyEtherLimit,"value no enough" );\n', '        require(sender != tokenWallet);\n', '        \n', '        if(DateConverter(now) > LastbetDay )\n', '        {\n', '            LastbetDay = DateConverter(now);\n', '            LeftDailyCap = dailyCap;\n', '        }\n', '\n', '        // Calculate token amount to be purchased\n', '        uint256 bonus = getBonusByTime();\n', '        \n', '        uint256 amount = value.mul(bonus);\n', '        \n', '        // We have enough token to sale\n', '        require(LeftDailyCap >= amount, "cap not enough");\n', '        require(balances[tokenWallet] >= amount);\n', '        \n', '        LeftDailyCap = LeftDailyCap.sub(amount);\n', '\n', '        // Transfer\n', '        balances[tokenWallet] = balances[tokenWallet].sub(amount);\n', '        balances[sender] = balances[sender].add(amount);\n', '        emit TokenPurchase(sender, value, amount);\n', '        emit Transfer(tokenWallet, sender, amount);\n', '        \n', '        saleCap = saleCap.sub(amount);\n', '\n', '        // Forward the fund to fund collection wallet.\n', '        fundWallet.transfer(msg.value);\n', '    }\n', '}']