['pragma solidity ^0.4.23;\n', '\n', '/*\n', '  Standard ERC20 Token.\n', '  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', '*/\n', 'contract ERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    uint public totalSupply;\n', '    mapping (address => uint) public balanceOf;\n', '    mapping (address => mapping (address => uint)) public allowance;\n', '\n', '    event Created(uint time);\n', '    event Transfer(address indexed from, address indexed to, uint amount);\n', '    event Approval(address indexed owner, address indexed spender, uint amount);\n', '    event AllowanceUsed(address indexed owner, address indexed spender, uint amount);\n', '\n', '    constructor(string _name, string _symbol)\n', '        public\n', '    {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        emit Created(now);\n', '    }\n', '\n', '    function transfer(address _to, uint _value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        return _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint _value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    // Attempts to transfer `_value` from `_from` to `_to`\n', '    //  if `_from` has sufficient allowance for `msg.sender`.\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        address _spender = msg.sender;\n', '        require(allowance[_from][_spender] >= _value);\n', '        allowance[_from][_spender] -= _value;\n', '        emit AllowanceUsed(_from, _spender, _value);\n', '        return _transfer(_from, _to, _value);\n', '    }\n', '\n', '    // Transfers balance from `_from` to `_to` if `_to` has sufficient balance.\n', '    // Called from transfer() and transferFrom().\n', '    function _transfer(address _from, address _to, uint _value)\n', '        private\n', '        returns (bool success)\n', '    {\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'interface HasTokenFallback {\n', '    function tokenFallback(address _from, uint256 _amount, bytes _data)\n', '        external\n', '        returns (bool success);\n', '}\n', 'contract ERC667 is ERC20 {\n', '    constructor(string _name, string _symbol)\n', '        public\n', '        ERC20(_name, _symbol)\n', '    {}\n', '\n', '    function transferAndCall(address _to, uint _value, bytes _data)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        require(super.transfer(_to, _value));\n', '        require(HasTokenFallback(_to).tokenFallback(msg.sender, _value, _data));\n', '        return true;\n', '    }\n', '}\n', '\n', '/*********************************************************\n', '******************* DIVIDEND TOKEN ***********************\n', '**********************************************************\n', '\n', 'UI: https://www.pennyether.com/status/tokens\n', '\n', 'An ERC20 token that can accept Ether and distribute it\n', 'perfectly to all Token Holders relative to each account&#39;s\n', 'balance at the time the dividend is received.\n', '\n', 'The Token is owned by the creator, and can be frozen,\n', 'minted, and burned by the owner.\n', '\n', 'Notes:\n', '    - Accounts can view or receive dividends owed at any time\n', '    - Dividends received are immediately credited to all\n', '      current Token Holders and can be redeemed at any time.\n', '    - Per above, upon transfers, dividends are not\n', '      transferred. They are kept by the original sender, and\n', '      not credited to the receiver.\n', '    - Uses "pull" instead of "push". Token holders must pull\n', '      their own dividends.\n', '\n', 'Comptroller Permissions:\n', '    - mintTokens(account, amt): via comp.fund() and comp.fundCapital()\n', '    - burnTokens(account, amt): via comp.burnTokens()\n', '    - setFrozen(true): Called before CrowdSale\n', '    - setFrozen(false): Called after CrowdSale, if softCap met\n', '*/\n', 'contract DividendToken is ERC667\n', '{\n', '    // if true, tokens cannot be transferred\n', '    bool public isFrozen;\n', '\n', '    // Comptroller can call .mintTokens() and .burnTokens().\n', '    address public comptroller = msg.sender;\n', '    modifier onlyComptroller(){ require(msg.sender==comptroller); _; }\n', '\n', '    // How dividends work:\n', '    //\n', '    // - A "point" is a fraction of a Wei (1e-32), it&#39;s used to reduce rounding errors.\n', '    //\n', '    // - totalPointsPerToken represents how many points each token is entitled to\n', '    //   from all the dividends ever received. Each time a new deposit is made, it\n', '    //   is incremented by the points oweable per token at the time of deposit:\n', '    //     (depositAmtInWei * POINTS_PER_WEI) / totalSupply\n', '    //\n', '    // - Each account has a `creditedPoints` and `lastPointsPerToken`\n', '    //   - lastPointsPerToken:\n', '    //       The value of totalPointsPerToken the last time `creditedPoints` was changed.\n', '    //   - creditedPoints:\n', '    //       How many points have been credited to the user. This is incremented by:\n', '    //         (`totalPointsPerToken` - `lastPointsPerToken` * balance) via\n', '    //         `.updateCreditedPoints(account)`. This occurs anytime the balance changes\n', '    //         (transfer, mint, burn).\n', '    //\n', '    // - .collectOwedDividends() calls .updateCreditedPoints(account), converts points\n', '    //   to wei and pays account, then resets creditedPoints[account] to 0.\n', '    //\n', '    // - "Credit" goes to Nick Johnson for the concept.\n', '    //\n', '    uint constant POINTS_PER_WEI = 1e32;\n', '    uint public dividendsTotal;\n', '    uint public dividendsCollected;\n', '    uint public totalPointsPerToken;\n', '    uint public totalBurned;\n', '    mapping (address => uint) public creditedPoints;\n', '    mapping (address => uint) public lastPointsPerToken;\n', '\n', '    // Events\n', '    event Frozen(uint time);\n', '    event UnFrozen(uint time);\n', '    event TokensMinted(uint time, address indexed account, uint amount, uint newTotalSupply);\n', '    event TokensBurned(uint time, address indexed account, uint amount, uint newTotalSupply);\n', '    event CollectedDividends(uint time, address indexed account, uint amount);\n', '    event DividendReceived(uint time, address indexed sender, uint amount);\n', '\n', '    constructor(string _name, string _symbol)\n', '        public\n', '        ERC667(_name, _symbol)\n', '    {}\n', '\n', '    // Upon receiving payment, increment lastPointsPerToken.\n', '    function ()\n', '        payable\n', '        public\n', '    {\n', '        if (msg.value == 0) return;\n', '        // POINTS_PER_WEI is 1e32.\n', '        // So, no multiplication overflow unless msg.value > 1e45 wei (1e27 ETH)\n', '        totalPointsPerToken += (msg.value * POINTS_PER_WEI) / totalSupply;\n', '        dividendsTotal += msg.value;\n', '        emit DividendReceived(now, msg.sender, msg.value);\n', '    }\n', '\n', '    /*************************************************************/\n', '    /******* COMPTROLLER FUNCTIONS *******************************/\n', '    /*************************************************************/\n', '    // Credits dividends, then mints more tokens.\n', '    function mint(address _to, uint _amount)\n', '        onlyComptroller\n', '        public\n', '    {\n', '        _updateCreditedPoints(_to);\n', '        totalSupply += _amount;\n', '        balanceOf[_to] += _amount;\n', '        emit TokensMinted(now, _to, _amount, totalSupply);\n', '    }\n', '    \n', '    // Credits dividends, burns tokens.\n', '    function burn(address _account, uint _amount)\n', '        onlyComptroller\n', '        public\n', '    {\n', '        require(balanceOf[_account] >= _amount);\n', '        _updateCreditedPoints(_account);\n', '        balanceOf[_account] -= _amount;\n', '        totalSupply -= _amount;\n', '        totalBurned += _amount;\n', '        emit TokensBurned(now, _account, _amount, totalSupply);\n', '    }\n', '\n', '    // when set to true, prevents tokens from being transferred\n', '    function freeze(bool _isFrozen)\n', '        onlyComptroller\n', '        public\n', '    {\n', '        if (isFrozen == _isFrozen) return;\n', '        isFrozen = _isFrozen;\n', '        if (_isFrozen) emit Frozen(now);\n', '        else emit UnFrozen(now);\n', '    }\n', '\n', '    /*************************************************************/\n', '    /********** PUBLIC FUNCTIONS *********************************/\n', '    /*************************************************************/\n', '    \n', '    // Normal ERC20 transfer, except before transferring\n', '    //  it credits points for both the sender and receiver.\n', '    function transfer(address _to, uint _value)\n', '        public\n', '        returns (bool success)\n', '    {   \n', '        // ensure tokens are not frozen.\n', '        require(!isFrozen);\n', '        _updateCreditedPoints(msg.sender);\n', '        _updateCreditedPoints(_to);\n', '        return ERC20.transfer(_to, _value);\n', '    }\n', '\n', '    // Normal ERC20 transferFrom, except before transferring\n', '    //  it credits points for both the sender and receiver.\n', '    function transferFrom(address _from, address _to, uint256 _value)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        require(!isFrozen);\n', '        _updateCreditedPoints(_from);\n', '        _updateCreditedPoints(_to);\n', '        return ERC20.transferFrom(_from, _to, _value);\n', '    }\n', '    \n', '    // Normal ERC667 transferAndCall, except before transferring\n', '    //  it credits points for both the sender and receiver.\n', '    function transferAndCall(address _to, uint _value, bytes _data)\n', '        public\n', '        returns (bool success)\n', '    {\n', '        require(!isFrozen);\n', '        _updateCreditedPoints(msg.sender);\n', '        _updateCreditedPoints(_to);\n', '        return ERC667.transferAndCall(_to, _value, _data);  \n', '    }\n', '\n', '    // Updates creditedPoints, sends all wei to the owner\n', '    function collectOwedDividends()\n', '        public\n', '        returns (uint _amount)\n', '    {\n', '        // update creditedPoints, store amount, and zero it.\n', '        _updateCreditedPoints(msg.sender);\n', '        _amount = creditedPoints[msg.sender] / POINTS_PER_WEI;\n', '        creditedPoints[msg.sender] = 0;\n', '        dividendsCollected += _amount;\n', '        emit CollectedDividends(now, msg.sender, _amount);\n', '        require(msg.sender.call.value(_amount)());\n', '    }\n', '\n', '\n', '    /*************************************************************/\n', '    /********** PRIVATE METHODS / VIEWS **************************/\n', '    /*************************************************************/\n', '    // Credits _account with whatever dividend points they haven&#39;t yet been credited.\n', '    //  This needs to be called before any user&#39;s balance changes to ensure their\n', '    //  "lastPointsPerToken" credits their current balance, and not an altered one.\n', '    function _updateCreditedPoints(address _account)\n', '        private\n', '    {\n', '        creditedPoints[_account] += _getUncreditedPoints(_account);\n', '        lastPointsPerToken[_account] = totalPointsPerToken;\n', '    }\n', '\n', '    // For a given account, returns how many Wei they haven&#39;t yet been credited.\n', '    function _getUncreditedPoints(address _account)\n', '        private\n', '        view\n', '        returns (uint _amount)\n', '    {\n', '        uint _pointsPerToken = totalPointsPerToken - lastPointsPerToken[_account];\n', '        // The upper bound on this number is:\n', '        //   ((1e32 * TOTAL_DIVIDEND_AMT) / totalSupply) * balances[_account]\n', '        // Since totalSupply >= balances[_account], this will overflow only if\n', '        //   TOTAL_DIVIDEND_AMT is around 1e45 wei. Not ever going to happen.\n', '        return _pointsPerToken * balanceOf[_account];\n', '    }\n', '\n', '\n', '    /*************************************************************/\n', '    /********* CONSTANTS *****************************************/\n', '    /*************************************************************/\n', '    // Returns how many wei a call to .collectOwedDividends() would transfer.\n', '    function getOwedDividends(address _account)\n', '        public\n', '        constant\n', '        returns (uint _amount)\n', '    {\n', '        return (_getUncreditedPoints(_account) + creditedPoints[_account])/POINTS_PER_WEI;\n', '    }\n', '}']