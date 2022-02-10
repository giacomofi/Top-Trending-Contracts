['pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, ownership can be transferred in 2 steps (transfer-accept).\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    address public pendingOwner;\n', '    bool isOwnershipTransferActive = false;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "Only owner can do that.");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier throws if called by any account other than the pendingOwner.\n', '     */\n', '    modifier onlyPendingOwner() {\n', '        require(isOwnershipTransferActive);\n', '        require(msg.sender == pendingOwner, "Only nominated pretender can do that.");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to set the pendingOwner address.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        pendingOwner = _newOwner;\n', '        isOwnershipTransferActive = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the pendingOwner address to finalize the transfer.\n', '     */\n', '    function acceptOwnership() public onlyPendingOwner {\n', '        emit OwnershipTransferred(owner, pendingOwner);\n', '        owner = pendingOwner;\n', '        isOwnershipTransferActive = false;\n', '        pendingOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 Token Standard Interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address _owner) public view returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '    function approve(address _spender, uint256 _value) public returns (bool);\n', '    function allowance(address _owner, address _spender) public view returns (uint256);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Aurum Services Presale Contract\n', ' * @author Igor D&#235;min\n', ' * @dev Presale accepting contributions only within a time frame and capped to specific amount.\n', ' */\n', 'contract AurumPresale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // How many minimal token units a buyer gets per wei, presale rate (1:5000 x 1.5)\n', '    uint256 public constant RATE = 7500;\n', '\n', '    // presale cap, 7.5M tokens to be sold\n', '    uint256 public constant CAP = 1000 ether;\n', '\n', '    // The token being sold\n', '    ERC20 public token;\n', '\n', '    // Crowdsale opening time\n', '    uint256 public openingTime;\n', '\n', '    // Crowdsale closing time\n', '    uint256 public closingTime;\n', '\n', '    // Amount of wei raised\n', '    uint256 public totalWeiRaised;\n', '\n', '    // address which can be specified by owner for service purposes\n', '    address controller;\n', '    bool isControllerSpecified = false;\n', '\n', '    /**\n', '     * Event for token purchase logging\n', '     * @param purchaser who paid for the tokens\n', '     * @param beneficiary who got the tokens\n', '     * @param value wei paid for purchase\n', '     * @param amount amount of tokens purchased\n', '     */\n', '    event TokenPurchase(\n', '        address indexed purchaser,\n', '        address indexed beneficiary,\n', '        uint256 value,\n', '        uint256 amount\n', '    );\n', '\n', '    constructor(ERC20 _token, uint256 _openingTime, uint256 _closingTime) public {\n', '        require(_token != address(0));\n', '        require(_openingTime >= now);\n', '        require(_closingTime > _openingTime);\n', '\n', '        token = _token;\n', '        openingTime = _openingTime;\n', '        closingTime = _closingTime;\n', '\n', '        require(token.balanceOf(msg.sender) >= RATE.mul(CAP));\n', '    }\n', '\n', '\n', '    modifier onlyWhileActive() {\n', '        require(isActive(), "Presale has closed.");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Sets minimal participation threshold\n', '     */\n', '    modifier minThreshold(uint256 _amount) {\n', '        require(msg.value >= _amount, "Not enough Ether provided.");\n', '        _;\n', '    }\n', '\n', '    modifier onlyController() {\n', '        require(isControllerSpecified);\n', '        require(msg.sender == controller, "Only controller can do that.");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev fallback function\n', '     */\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Reclaim all ERC20 compatible tokens\n', '     * @param _token ERC20 The address of the token contract\n', '     */\n', '    function reclaimToken(ERC20 _token) external onlyOwner {\n', '        require(!isActive());\n', '        uint256 tokenBalance = _token.balanceOf(this);\n', '        require(_token.transfer(owner, tokenBalance));\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer all Ether held by the contract to the owner.\n', '     */\n', '    function reclaimEther() external onlyOwner {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '\n', '    /**\n', '     * @dev Specifies service account\n', '     */\n', '    function specifyController(address _controller) external onlyOwner {\n', '        controller = _controller;\n', '        isControllerSpecified = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Controller can mark the receipt of funds attracted in other cryptocurrencies,\n', '     * in equivalent of ether.\n', '     */\n', '    function markFunding(address _beneficiary, uint256 _weiRaised)\n', '        external\n', '        onlyController\n', '        onlyWhileActive\n', '    {\n', '        require(_beneficiary != address(0));\n', '        require(_weiRaised >= 20 finney);\n', '\n', '        enroll(controller, _beneficiary, _weiRaised);\n', '    }\n', '\n', '    /**\n', '     * @dev Checks whether the period in which the pre-sale is open has already elapsed and\n', '     * whether pre-sale cap has been reached.\n', '     */\n', '    function isActive() public view returns (bool) {\n', '        return now >= openingTime && now <= closingTime && !capReached();\n', '    }\n', '\n', '    /**\n', '     * @dev Token purchase\n', '     * @param _beneficiary Address performing the token purchase\n', '     */\n', '    function buyTokens(address _beneficiary)\n', '        public\n', '        payable\n', '        onlyWhileActive\n', '        minThreshold(20 finney)\n', '    {\n', '        require(_beneficiary != address(0));\n', '\n', '        uint256 newWeiRaised = msg.value;\n', '        uint256 newTotalWeiRaised = totalWeiRaised.add(newWeiRaised);\n', '\n', '        uint256 refundValue = 0;\n', '        if (newTotalWeiRaised > CAP) {\n', '            newWeiRaised = CAP.sub(totalWeiRaised);\n', '            refundValue = newTotalWeiRaised.sub(CAP);\n', '        }\n', '\n', '        enroll(msg.sender, _beneficiary, newWeiRaised);\n', '\n', '        if (refundValue > 0) {\n', '            msg.sender.transfer(refundValue);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Checks whether the cap has been reached.\n', '     * @return Whether the cap was reached\n', '     */\n', '    function capReached() internal view returns (bool) {\n', '        return totalWeiRaised >= CAP;\n', '    }\n', '\n', '    /**\n', '     * @dev Calculate amount of tokens.\n', '     * @param _weiAmount Value in wei to be converted into tokens\n', '     * @return Number of tokens that can be purchased with the specified _weiAmount\n', '     */\n', '    function getTokenAmount(uint256 _weiAmount) internal pure returns (uint256) {\n', '        return _weiAmount.mul(RATE);\n', '    }\n', '\n', '    /**\n', '     * @dev common logic for enroll funds\n', '     */\n', '    function enroll(address _purchaser, address _beneficiary, uint256 _value) private {\n', '        // update sale progress\n', '        totalWeiRaised = totalWeiRaised.add(_value);\n', '\n', '        // calculate token amount\n', '        uint256 tokenAmount = getTokenAmount(_value);\n', '\n', '        require(token.transfer(_beneficiary, tokenAmount));\n', '        emit TokenPurchase(_purchaser, _beneficiary, _value, tokenAmount);\n', '    }\n', '\n', '}']
['pragma solidity 0.4.24;\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, ownership can be transferred in 2 steps (transfer-accept).\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '    address public pendingOwner;\n', '    bool isOwnershipTransferActive = false;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner, "Only owner can do that.");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier throws if called by any account other than the pendingOwner.\n', '     */\n', '    modifier onlyPendingOwner() {\n', '        require(isOwnershipTransferActive);\n', '        require(msg.sender == pendingOwner, "Only nominated pretender can do that.");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to set the pendingOwner address.\n', '     * @param _newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        pendingOwner = _newOwner;\n', '        isOwnershipTransferActive = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the pendingOwner address to finalize the transfer.\n', '     */\n', '    function acceptOwnership() public onlyPendingOwner {\n', '        emit OwnershipTransferred(owner, pendingOwner);\n', '        owner = pendingOwner;\n', '        isOwnershipTransferActive = false;\n', '        pendingOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 Token Standard Interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address _owner) public view returns (uint256);\n', '    function transfer(address _to, uint256 _value) public returns (bool);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '    function approve(address _spender, uint256 _value) public returns (bool);\n', '    function allowance(address _owner, address _spender) public view returns (uint256);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/**\n', ' * @title Aurum Services Presale Contract\n', ' * @author Igor Dëmin\n', ' * @dev Presale accepting contributions only within a time frame and capped to specific amount.\n', ' */\n', 'contract AurumPresale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // How many minimal token units a buyer gets per wei, presale rate (1:5000 x 1.5)\n', '    uint256 public constant RATE = 7500;\n', '\n', '    // presale cap, 7.5M tokens to be sold\n', '    uint256 public constant CAP = 1000 ether;\n', '\n', '    // The token being sold\n', '    ERC20 public token;\n', '\n', '    // Crowdsale opening time\n', '    uint256 public openingTime;\n', '\n', '    // Crowdsale closing time\n', '    uint256 public closingTime;\n', '\n', '    // Amount of wei raised\n', '    uint256 public totalWeiRaised;\n', '\n', '    // address which can be specified by owner for service purposes\n', '    address controller;\n', '    bool isControllerSpecified = false;\n', '\n', '    /**\n', '     * Event for token purchase logging\n', '     * @param purchaser who paid for the tokens\n', '     * @param beneficiary who got the tokens\n', '     * @param value wei paid for purchase\n', '     * @param amount amount of tokens purchased\n', '     */\n', '    event TokenPurchase(\n', '        address indexed purchaser,\n', '        address indexed beneficiary,\n', '        uint256 value,\n', '        uint256 amount\n', '    );\n', '\n', '    constructor(ERC20 _token, uint256 _openingTime, uint256 _closingTime) public {\n', '        require(_token != address(0));\n', '        require(_openingTime >= now);\n', '        require(_closingTime > _openingTime);\n', '\n', '        token = _token;\n', '        openingTime = _openingTime;\n', '        closingTime = _closingTime;\n', '\n', '        require(token.balanceOf(msg.sender) >= RATE.mul(CAP));\n', '    }\n', '\n', '\n', '    modifier onlyWhileActive() {\n', '        require(isActive(), "Presale has closed.");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Sets minimal participation threshold\n', '     */\n', '    modifier minThreshold(uint256 _amount) {\n', '        require(msg.value >= _amount, "Not enough Ether provided.");\n', '        _;\n', '    }\n', '\n', '    modifier onlyController() {\n', '        require(isControllerSpecified);\n', '        require(msg.sender == controller, "Only controller can do that.");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev fallback function\n', '     */\n', '    function () external payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Reclaim all ERC20 compatible tokens\n', '     * @param _token ERC20 The address of the token contract\n', '     */\n', '    function reclaimToken(ERC20 _token) external onlyOwner {\n', '        require(!isActive());\n', '        uint256 tokenBalance = _token.balanceOf(this);\n', '        require(_token.transfer(owner, tokenBalance));\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer all Ether held by the contract to the owner.\n', '     */\n', '    function reclaimEther() external onlyOwner {\n', '        owner.transfer(address(this).balance);\n', '    }\n', '\n', '    /**\n', '     * @dev Specifies service account\n', '     */\n', '    function specifyController(address _controller) external onlyOwner {\n', '        controller = _controller;\n', '        isControllerSpecified = true;\n', '    }\n', '\n', '    /**\n', '     * @dev Controller can mark the receipt of funds attracted in other cryptocurrencies,\n', '     * in equivalent of ether.\n', '     */\n', '    function markFunding(address _beneficiary, uint256 _weiRaised)\n', '        external\n', '        onlyController\n', '        onlyWhileActive\n', '    {\n', '        require(_beneficiary != address(0));\n', '        require(_weiRaised >= 20 finney);\n', '\n', '        enroll(controller, _beneficiary, _weiRaised);\n', '    }\n', '\n', '    /**\n', '     * @dev Checks whether the period in which the pre-sale is open has already elapsed and\n', '     * whether pre-sale cap has been reached.\n', '     */\n', '    function isActive() public view returns (bool) {\n', '        return now >= openingTime && now <= closingTime && !capReached();\n', '    }\n', '\n', '    /**\n', '     * @dev Token purchase\n', '     * @param _beneficiary Address performing the token purchase\n', '     */\n', '    function buyTokens(address _beneficiary)\n', '        public\n', '        payable\n', '        onlyWhileActive\n', '        minThreshold(20 finney)\n', '    {\n', '        require(_beneficiary != address(0));\n', '\n', '        uint256 newWeiRaised = msg.value;\n', '        uint256 newTotalWeiRaised = totalWeiRaised.add(newWeiRaised);\n', '\n', '        uint256 refundValue = 0;\n', '        if (newTotalWeiRaised > CAP) {\n', '            newWeiRaised = CAP.sub(totalWeiRaised);\n', '            refundValue = newTotalWeiRaised.sub(CAP);\n', '        }\n', '\n', '        enroll(msg.sender, _beneficiary, newWeiRaised);\n', '\n', '        if (refundValue > 0) {\n', '            msg.sender.transfer(refundValue);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Checks whether the cap has been reached.\n', '     * @return Whether the cap was reached\n', '     */\n', '    function capReached() internal view returns (bool) {\n', '        return totalWeiRaised >= CAP;\n', '    }\n', '\n', '    /**\n', '     * @dev Calculate amount of tokens.\n', '     * @param _weiAmount Value in wei to be converted into tokens\n', '     * @return Number of tokens that can be purchased with the specified _weiAmount\n', '     */\n', '    function getTokenAmount(uint256 _weiAmount) internal pure returns (uint256) {\n', '        return _weiAmount.mul(RATE);\n', '    }\n', '\n', '    /**\n', '     * @dev common logic for enroll funds\n', '     */\n', '    function enroll(address _purchaser, address _beneficiary, uint256 _value) private {\n', '        // update sale progress\n', '        totalWeiRaised = totalWeiRaised.add(_value);\n', '\n', '        // calculate token amount\n', '        uint256 tokenAmount = getTokenAmount(_value);\n', '\n', '        require(token.transfer(_beneficiary, tokenAmount));\n', '        emit TokenPurchase(_purchaser, _beneficiary, _value, tokenAmount);\n', '    }\n', '\n', '}']