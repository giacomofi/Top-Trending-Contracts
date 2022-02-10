['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-07\n', '*/\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'library SafeMath {\n', '    \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return _sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function _sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return _div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function _div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return _mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function _mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', ' interface IERC20 {\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function allowance(address owner, address spender) external  view returns (uint256);\n', '    function transfer(address to, uint256 value) external  returns (bool ok);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool ok);\n', '    function approve(address spender, uint256 value)external returns (bool ok);\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '}\n', '\n', 'contract BitmindCrowdsale {\n', '    using SafeMath for uint256;\n', '\n', '    struct Participant {\n', '        uint256 amount;   // How many tokens the user has provided.\n', '    }\n', '    struct CrowdsaleHistory {\n', '        uint256 id;\n', '        uint256 start_time;\n', '        uint256 end_time;\n', '        uint256 initial_price;\n', '        uint256 final_price;\n', '        uint256 final_cap;\n', '        uint256 total_received;\n', '        uint256 token_available;\n', '        uint256 token_sold;\n', '    }\n', '      \n', '    modifier onlyOwner {\n', "        require(msg.sender == owner, 'BitmindMsg: Only Owner'); \n", '        _;\n', '    }\n', '    modifier onlyWhileOpen{\n', '        //Validation Crowdsale\n', "        require(start_time > 0 && end_time > 0 , 'BitmindMsg: Crowdsale is not started yet');\n", "        require(block.timestamp > start_time && block.timestamp < end_time, 'BitmindMsg: Crowdsale is not started yet');\n", '        _;\n', '    }\n', '     \n', '    modifier onlyFreezer{\n', "        require(msg.sender == freezerAddress, 'BitmindMsg: Only Freezer Address');\n", '        _;\n', '    }\n', '\n', '    /**\n', '     * Configurator Crowdsale Contract\n', '     */\n', '    address payable private owner;\n', '    address private freezerAddress;\n', '\n', '    /**\n', '     * Token Address for Crowdsale Contract\n', '     */\n', '    IERC20 private tokenAddress;\n', '    IERC20 private pairAddress;\n', '    \n', '    /**\n', '     * Time Configuration\n', '     */\n', '    uint256 private start_time;\n', '    uint256 private end_time;\n', '    bool private pause;\n', '    \n', '    /** \n', '     * Crowdsale Information\n', '     */\n', '    uint256 private min_contribution;\n', '    uint256 private max_contribution;\n', '    uint256 public cap;\n', '    uint256 private rate;\n', '    uint256 private price;\n', '    uint256 public token_available;\n', '    uint256 public total_received;\n', '    uint256 public token_sold;\n', '    \n', '    /**\n', '     * Participant Information\n', '     */\n', '    mapping (address => Participant) public userInfo;\n', '    address[] private addressList;\n', '    \n', '    mapping (uint256 => CrowdsaleHistory) public crowdsaleInfo;\n', '    uint256[] private crowdsaleid;\n', '\n', '    /**\n', '     * Event for token purchase logging\n', '     * @param purchaser : who paid for the tokens and get the tokens\n', '     * @param amount : total amount of tokens purchased\n', '     */\n', '    event TokensPurchased(address indexed purchaser, uint256 amount);\n', '    \n', '    /**\n', '     * Event shown after change Opening Time \n', '     * @param owner : who owner this contract\n', '     * @param openingtime : time when the Crowdsale started\n', '     */\n', '    event setOpeningtime(address indexed owner, uint256 openingtime);\n', '    \n', '    /**\n', '     * Event shown after change Closing Time\n', '     * @param owner : who owner this contract\n', '     * @param closingtime : time when the Crowdsale Ended\n', '     */\n', '    event setClosingtime(address indexed owner, uint256 closingtime);\n', '    \n', '     /**\n', '     * Event for withdraw usdt token from contract to owner\n', '     * @param owner : who owner this contract\n', '     * @param amount : time when the Crowdsale Ended\n', '     */\n', '    event WithdrawUSDT(address indexed owner, uint256 amount);\n', '    \n', '    /**\n', '     * Event for withdraw bmd token from contract to owner\n', '     * @param owner : who owner this contract\n', '     * @param amount : time when the Crowdsale Ended\n', '     */\n', '    event WithdrawBMD(address indexed owner, uint256 amount);\n', '  \n', '  /**\n', '     * Event for Transfer Ownership\n', '     * @param previousOwner : owner Crowdsale contract\n', '     * @param newOwner : New Owner of Crowdsale contract\n', '     * @param time : time when changeOwner function executed\n', '     */\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner, uint256 time);\n', '    \n', '    /**\n', '     * Event for Transfer Freezer Admin\n', '     * @param previousFreezer : Freezer of Crowdsale contract\n', '     * @param newFreezer : new Freezer of Crowdsale contract\n', '     * @param time : time when transferFreezer function executed\n', '     */\n', '    event FreezerTransferred(address indexed previousFreezer, address indexed newFreezer, uint256 time);\n', '    \n', '     /**\n', '     * Event for Freeze the Crowdsale\n', '     * @param FreezerAddress : Address who can freeze Crowdsale contract\n', '     * @param time : time when changeOwner function executed\n', '     */\n', '    event FreezeCrowdsale(address indexed FreezerAddress, uint256 time);\n', '    \n', '    /**\n', '     * Event for Unfreeze the Crowdsale\n', '     * @param FreezerAddress : Address who can freeze Crowdsale contract\n', '     * @param time : time when changeOwner function executed\n', '     */\n', '    event UnfreezeCrowdsale(address indexed FreezerAddress, uint256 time);\n', '    \n', '    /**\n', '     * Event for Initializing Crowdsale Contract\n', '     * @param Token : Main Token which will be distributed in Crowdsale\n', '     * @param Pair : Pair Token which will be used for transaction in Crowdsale\n', '     * @param owner : Address who can initialize Crowdsale contract\n', '     * @param min_contribution : min contribution for transaction in Crowdsale\n', '     * @param max_contribution : max contribution for transaction in Crowdsale\n', '     * @param start_time : time when the Crowdsale starts\n', '     * @param end_time : time when the Crowdsale ends\n', '     * @param rate : increasing price every period\n', '     * @param initial_price : initial price of Crowdsale\n', '     */\n', '    event Initializing(\n', '        address indexed Token,\n', '        address indexed Pair,\n', '        address indexed owner, \n', '        uint256 min_contribution, \n', '        uint256 max_contribution,\n', '        uint256 start_time,\n', '        uint256 end_time,\n', '        uint256 rate,\n', '        uint256 initial_price\n', '    );\n', '\n', '    /**\n', '     * Constructor of Bitmind Crowdsale Contract\n', '     */\n', '     \n', '    constructor() public {\n', '        owner = msg.sender;\n', '        freezerAddress = msg.sender;\n', '        pause = false;\n', '    }\n', '    \n', '    /**\n', '     * Function for Initialize default configuration of Crowdsale\n', '     */\n', '    function initialize(\n', '        address Token,\n', '        address Pair,\n', '        uint256 MinContribution,\n', '        uint256 MaxContribution,\n', '        uint256 initial_cap,\n', '        uint256 StartTime,\n', '        uint256 EndTime,\n', '        uint256 initial_price,\n', '        uint256 initial_rate\n', '    ) public onlyOwner returns(bool){\n', '        tokenAddress = IERC20(Token);\n', '        pairAddress = IERC20(Pair);\n', '        \n', '        require(initial_price > 0 , "BitmindMsg: initial price must higher than 0");\n', '        price = initial_price;\n', '        \n', '        require(StartTime > 0, "BitmindMsg: start_time must higher than 0");\n', '        start_time = StartTime;\n', '        \n', '        require(EndTime > 0, "BitmindMsg: end_time must higher than 0");\n', '        end_time = EndTime;\n', '        \n', '        require(MinContribution > 0, "BitmindMsg: min_contribution must higher than 0");\n', '        min_contribution = MinContribution;\n', '        \n', '        require(MaxContribution > 0, "BitmindMsg: max_contribution must higher than 0");\n', '        max_contribution = MaxContribution;\n', '        \n', '        require(initial_rate > 0, "BitmindMsg: initial_rate must higher than 0");\n', '        rate = initial_rate;\n', '        \n', '        \n', '        cap = initial_cap;\n', '        token_available = initial_cap;\n', '        token_sold = 0;\n', '        total_received = 0;\n', '        \n', '        uint256 id = crowdsaleid.length.add(1);\n', '        crowdsaleid.push(id);\n', '        crowdsaleInfo[id].id = id;\n', '        crowdsaleInfo[id].start_time = StartTime;\n', '        crowdsaleInfo[id].end_time = EndTime;\n', '        crowdsaleInfo[id].initial_price = initial_price;\n', '        crowdsaleInfo[id].final_price = initial_price;\n', '        crowdsaleInfo[id].final_cap = initial_cap;\n', '        crowdsaleInfo[id].token_available = token_available;\n', '        \n', '        emit Initializing(Token, Pair, msg.sender, MinContribution, MaxContribution, StartTime, EndTime, initial_rate, initial_price);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Function for Purchase Token on Crowdsale\n', '     * @param amount : amount which user purchase\n', '     * \n', '     * return deliveryTokens\n', '     */\n', '    \n', '    function Purchase(uint256 amount) external onlyWhileOpen returns(bool){\n', '        \n', "        require(pause == false, 'BitmindMsg: Crowdsale is freezing');\n", '        \n', "        require(price > 0, 'BitmindMsg: Initial Prize is not set yet');\n", '        \n', '        if (min_contribution > 0 && max_contribution > 0 ){\n', '            require(amount >= min_contribution && amount <= max_contribution, "BitmindMsg: Amount invalid");\n', '        }\n', '        \n', '        uint256 tokenReached = getEstimateToken(amount);\n', '        require(tokenReached > 0, "BitmindMsg: Calculating Error!");\n', '        require(token_available > 0 && token_available >= tokenReached, "BitmindMsg: INSUFFICIENT BMD");\n', '        \n', '        pairAddress.transferFrom(msg.sender, address(this), amount.div(1e12));\n', '        total_received = total_received.add(amount);\n', '        \n', '        crowdsaleInfo[crowdsaleid.length].total_received = total_received;\n', '        crowdsaleInfo[crowdsaleid.length].final_price = getPrice();\n', '        \n', '        if (userInfo[msg.sender].amount == 0) {\n', '          addressList.push(address(msg.sender));\n', '        }\n', '        userInfo[msg.sender].amount = userInfo[msg.sender].amount.add(amount);\n', '        \n', '        token_available = token_available.sub(tokenReached);\n', '        token_sold = token_sold.add(tokenReached);\n', '        \n', '        crowdsaleInfo[crowdsaleid.length].token_available = token_available;\n', '        crowdsaleInfo[crowdsaleid.length].token_sold = token_sold;\n', '    \n', '        tokenAddress.transfer(msg.sender, tokenReached);\n', '        \n', '        emit TokensPurchased(msg.sender, tokenReached);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Function for Estimate token which user get on Crowdsale\n', '     * @param _amount : amount which user purchase\n', '     * \n', '     * return token_amount type uint256\n', '     */\n', '    function getEstimateToken(uint256 _amount) private view returns(uint256) {\n', '        \n', '        uint256 token_amount;\n', '        uint256 a;\n', '        uint256 b;\n', '        uint256 phase_1 = cap.mul(50).div(100);\n', '        uint256 phase_2 = cap.mul(80).div(100);\n', '        uint256 phase_3 = cap.mul(100).div(100);\n', '        \n', '        uint256 get = _amount.div(getPrice().div(1e18));\n', '        if(token_available > cap.sub(phase_1)){\n', '            if(token_available.sub(get) < cap.sub(phase_1)){\n', '                a = token_available.sub(cap.sub(phase_1));\n', '                b = _amount.sub(a.mul(getPrice().div(1e18))).div(price.add(rate.mul(1)).div(1e18));\n', '                token_amount = a.add(b);\n', '            }else{\n', '                token_amount = get;\n', '            }\n', '        }else if(token_available > cap.sub(phase_2)){\n', '            if(token_available.sub(get) < cap.sub(phase_2)){\n', '                a = token_available.sub(cap.sub(phase_2));\n', '                b = _amount.sub(a.mul(getPrice().div(1e18))).div(price.add(rate.mul(2)).div(1e18));\n', '                token_amount = a.add(b);\n', '            }else{\n', '                token_amount = get;\n', '            }\n', '        }else if(token_available > cap.sub(phase_3)){\n', '            if(token_available.sub(get) < cap.sub(phase_3)){\n', '                token_amount = token_available.sub(phase_3);\n', '            }else{\n', '                token_amount = get;\n', '            }\n', '        }\n', '        return token_amount;\n', '    }\n', '    \n', '    /**\n', '     * Function for getting current price\n', '     * \n', '     * return price (uint256)\n', '     */\n', '    \n', '    function getPrice() public view returns(uint256){\n', '        require(price > 0 && token_available > 0 && cap > 0, "BitmindMsg: Initializing contract first");\n', '        \n', '        if(token_available > cap.sub(cap.mul(50).div(100))){\n', '            return price;\n', '        }else if(token_available > cap.sub(cap.mul(80).div(100))){\n', '            return price.add(rate.mul(1));\n', '        }else if(token_available > cap.sub(cap.mul(100).div(100))){\n', '            return price.add(rate.mul(2));\n', '        }else{\n', '            return price.add(rate.mul(2));\n', '        }\n', '    }\n', '    \n', '    \n', '    /**\n', '     * Function for withdraw usdt token on Crowdsale\n', '     * \n', '     * return event WithdrawUSDT\n', '     */\n', '     \n', '    function withdrawUSDT() public onlyOwner returns(bool){\n', "         require(total_received>0, 'BitmindMsg: Pair Token INSUFFICIENT');\n", '         \n', '         uint256 balance = pairAddress.balanceOf(address(this));\n', '         pairAddress.transfer(msg.sender, balance);\n', '         emit WithdrawUSDT(msg.sender,balance);\n', '         return true;\n', '    }\n', '    \n', '     /**\n', '     * Function for withdraw bmd token on Crowdsale\n', '     * \n', '     * return event WithdrawUSDT\n', '     */\n', '     \n', '    function withdrawBMD() public onlyOwner returns(bool){\n', "         require(token_available > 0, 'BitmindMsg: Distributed Token INSUFFICIENT');\n", '         \n', '         uint256 balance = tokenAddress.balanceOf(address(this));\n', '         tokenAddress.transfer(owner, balance);\n', '         emit WithdrawBMD(msg.sender, balance);\n', '         return true;\n', '    }\n', '    \n', '    /**\n', '     * Function to get opening time of Crowdsale\n', '     */\n', '    \n', '    function openingTime() public view returns(uint256){\n', '        return start_time;\n', '    }\n', '    \n', '    /**\n', '     * Function to get closing time of Crowdsale\n', '     */\n', '    \n', '    function closingTime() public view returns(uint256){\n', '        return end_time;\n', '    }\n', '    \n', '    /**\n', '     * Function to get minimum contribution of Crowdsale\n', '     */\n', '    function MIN_CONTRIBUTION() public view returns(uint256){\n', '         return min_contribution;\n', '    }\n', '    /**\n', '     * Function to get maximum contribution of Crowdsale\n', '     */\n', '    function MAX_CONTRIBUTION() public view returns(uint256){\n', '        return max_contribution;\n', '    }\n', '      \n', '    /**\n', '     * Function to get rate which user get during transaction per 1 pair on Crowdsale \n', '     */\n', '    function Rate() public view returns(uint256){\n', '        return rate;\n', '    }\n', '    /**\n', '     * Function to get status of Crowdsale which user get during transaction per 1 pair on Crowdsale \n', '     */\n', '    function Pause() public view returns(bool){\n', '        return pause;\n', '    }\n', '    \n', '    /**\n', '     * Function to get total participant of Crowdsale\n', '     * \n', '     * return total participant\n', '     */\n', '    \n', '    function totalParticipant() public view returns(uint){\n', '        return addressList.length;\n', '    }\n', '    \n', '    /**\n', '     * Function to set opening time of Crowdsale\n', '     * @param _time : time for opening time\n', '     * \n', '     * return event OpeningTime\n', '     */\n', '     \n', '    function changeOpeningTime(uint256 _time) public onlyOwner returns(bool) {\n', '        require(_time >= block.timestamp, "BitmindMsg: Opening Time must before current time");\n', '        \n', '        start_time = _time;\n', '        emit setOpeningtime(owner, _time);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Function to set closing time of Crowdsale\n', '     * @param _time : time for opening time\n', '     * \n', '     * return event ClosingTime\n', '     */\n', '    function changeClosingTime(uint256 _time) public onlyOwner returns(bool) {\n', '        require(_time >= start_time, "BitmindMsg: Closing Time already set");\n', '        \n', '        end_time = _time;\n', '        emit setClosingtime(owner, _time);\n', '        return true;\n', '    }\n', '    \n', '     /**\n', '     * Function to change Crowdsale contract Owner\n', '     * Only Owner who could access this function\n', '     * \n', '     * return event OwnershipTransferred\n', '     */\n', '    \n', '    function transferOwnership(address payable _owner) onlyOwner public returns(bool) {\n', '        owner = _owner;\n', '        \n', '        emit OwnershipTransferred(msg.sender, _owner, block.timestamp);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Function to change Freezer Address\n', '     * Only Freezer who could access this function\n', '     * \n', '     * return event FreezerTransferred\n', '     */\n', '    \n', '    function transferFreezer(address freezer) onlyFreezer public returns(bool){\n', '        freezerAddress = freezer;\n', '        \n', '        emit FreezerTransferred(msg.sender, freezer, block.timestamp);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Function to freeze or pause crowdsale\n', '     * Only Freezer who could access this function\n', '     * \n', '     * return true\n', '     */\n', '    \n', '    function freeze() public onlyFreezer returns(bool) {\n', '        pause = true;\n', '        \n', '        emit FreezeCrowdsale(freezerAddress, block.timestamp);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '     * Function to unfreeze or pause crowdsale\n', '     * Only Freezer who could access this function\n', '     * \n', '     * return true\n', '     */\n', '    \n', '    function unfreeze() public onlyFreezer returns(bool) {\n', '        pause = false;\n', '        \n', '        emit UnfreezeCrowdsale(freezerAddress, block.timestamp);\n', '        return true;\n', '    }\n', '}']