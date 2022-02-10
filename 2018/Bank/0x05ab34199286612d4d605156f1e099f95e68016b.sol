['pragma solidity 0.4.18;\n', '\n', 'interface ERC20 {\n', '    function totalSupply() public view returns (uint supply);\n', '    function balanceOf(address _owner) public view returns (uint balance);\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint remaining);\n', '    function decimals() public view returns(uint digits);\n', '    event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '}\n', '\n', 'contract PermissionGroups {\n', '\n', '    address public admin;\n', '    address public pendingAdmin;\n', '    mapping(address=>bool) internal operators;\n', '    mapping(address=>bool) internal alerters;\n', '    address[] internal operatorsGroup;\n', '    address[] internal alertersGroup;\n', '\n', '    function PermissionGroups() public {\n', '        admin = msg.sender;\n', '    }\n', '\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    modifier onlyOperator() {\n', '        require(operators[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAlerter() {\n', '        require(alerters[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function getOperators () external view returns(address[]) {\n', '        return operatorsGroup;\n', '    }\n', '\n', '    function getAlerters () external view returns(address[]) {\n', '        return alertersGroup;\n', '    }\n', '\n', '    event TransferAdminPending(address pendingAdmin);\n', '\n', '    /**\n', '     * @dev Allows the current admin to set the pendingAdmin address.\n', '     * @param newAdmin The address to transfer ownership to.\n', '     */\n', '    function transferAdmin(address newAdmin) public onlyAdmin {\n', '        require(newAdmin != address(0));\n', '        TransferAdminPending(pendingAdmin);\n', '        pendingAdmin = newAdmin;\n', '    }\n', '\n', '    event AdminClaimed( address newAdmin, address previousAdmin);\n', '\n', '    /**\n', '     * @dev Allows the pendingAdmin address to finalize the change admin process.\n', '     */\n', '    function claimAdmin() public {\n', '        require(pendingAdmin == msg.sender);\n', '        AdminClaimed(pendingAdmin, admin);\n', '        admin = pendingAdmin;\n', '        pendingAdmin = address(0);\n', '    }\n', '\n', '    event AlerterAdded (address newAlerter, bool isAdd);\n', '\n', '    function addAlerter(address newAlerter) public onlyAdmin {\n', '        require(!alerters[newAlerter]); // prevent duplicates.\n', '        AlerterAdded(newAlerter, true);\n', '        alerters[newAlerter] = true;\n', '        alertersGroup.push(newAlerter);\n', '    }\n', '\n', '    function removeAlerter (address alerter) public onlyAdmin {\n', '        require(alerters[alerter]);\n', '        alerters[alerter] = false;\n', '\n', '        for (uint i = 0; i < alertersGroup.length; ++i) {\n', '            if (alertersGroup[i] == alerter) {\n', '                alertersGroup[i] = alertersGroup[alertersGroup.length - 1];\n', '                alertersGroup.length--;\n', '                AlerterAdded(alerter, false);\n', '                break;\n', '            }\n', '        }\n', '    }\n', '\n', '    event OperatorAdded(address newOperator, bool isAdd);\n', '\n', '    function addOperator(address newOperator) public onlyAdmin {\n', '        require(!operators[newOperator]); // prevent duplicates.\n', '        OperatorAdded(newOperator, true);\n', '        operators[newOperator] = true;\n', '        operatorsGroup.push(newOperator);\n', '    }\n', '\n', '    function removeOperator (address operator) public onlyAdmin {\n', '        require(operators[operator]);\n', '        operators[operator] = false;\n', '\n', '        for (uint i = 0; i < operatorsGroup.length; ++i) {\n', '            if (operatorsGroup[i] == operator) {\n', '                operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];\n', '                operatorsGroup.length -= 1;\n', '                OperatorAdded(operator, false);\n', '                break;\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'interface BurnableToken {\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool);\n', '    function burnFrom(address _from, uint256 _value) public returns (bool);\n', '}\n', '\n', 'contract Withdrawable is PermissionGroups {\n', '\n', '    event TokenWithdraw(ERC20 token, uint amount, address sendTo);\n', '\n', '    /**\n', '     * @dev Withdraw all ERC20 compatible tokens\n', '     * @param token ERC20 The address of the token contract\n', '     */\n', '    function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {\n', '        require(token.transfer(sendTo, amount));\n', '        TokenWithdraw(token, amount, sendTo);\n', '    }\n', '\n', '    event EtherWithdraw(uint amount, address sendTo);\n', '\n', '    /**\n', '     * @dev Withdraw Ethers\n', '     */\n', '    function withdrawEther(uint amount, address sendTo) external onlyAdmin {\n', '        sendTo.transfer(amount);\n', '        EtherWithdraw(amount, sendTo);\n', '    }\n', '}\n', '\n', 'interface FeeBurnerInterface {\n', '    function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);\n', '}\n', '\n', 'contract FeeBurner is Withdrawable, FeeBurnerInterface {\n', '\n', '    mapping(address=>uint) public reserveFeesInBps;\n', '    mapping(address=>address) public reserveKNCWallet;\n', '    mapping(address=>uint) public walletFeesInBps;\n', '    mapping(address=>uint) public reserveFeeToBurn;\n', '    mapping(address=>mapping(address=>uint)) public reserveFeeToWallet;\n', '\n', '    BurnableToken public knc;\n', '    address public kyberNetwork;\n', '    uint public kncPerETHRate = 300;\n', '\n', '    function FeeBurner(address _admin, BurnableToken kncToken) public {\n', '        require(_admin != address(0));\n', '        require(kncToken != address(0));\n', '        admin = _admin;\n', '        knc = kncToken;\n', '    }\n', '\n', '    function setReserveData(address reserve, uint feesInBps, address kncWallet) public onlyAdmin {\n', '        require(feesInBps < 100); // make sure it is always < 1%\n', '        require(kncWallet != address(0));\n', '        reserveFeesInBps[reserve] = feesInBps;\n', '        reserveKNCWallet[reserve] = kncWallet;\n', '    }\n', '\n', '    function setWalletFees(address wallet, uint feesInBps) public onlyAdmin {\n', '        require(feesInBps < 10000); // under 100%\n', '        walletFeesInBps[wallet] = feesInBps;\n', '    }\n', '\n', '    function setKyberNetwork(address _kyberNetwork) public onlyAdmin {\n', '        require(_kyberNetwork != address(0));\n', '        kyberNetwork = _kyberNetwork;\n', '    }\n', '\n', '    function setKNCRate(uint rate) public onlyAdmin {\n', '        kncPerETHRate = rate;\n', '    }\n', '\n', '    event AssignFeeToWallet(address reserve, address wallet, uint walletFee);\n', '    event AssignBurnFees(address reserve, uint burnFee);\n', '\n', '    function handleFees(uint tradeWeiAmount, address reserve, address wallet) public returns(bool) {\n', '        require(msg.sender == kyberNetwork);\n', '\n', '        uint kncAmount = tradeWeiAmount * kncPerETHRate;\n', '        uint fee = kncAmount * reserveFeesInBps[reserve] / 10000;\n', '\n', '        uint walletFee = fee * walletFeesInBps[wallet] / 10000;\n', '        require(fee >= walletFee);\n', '        uint feeToBurn = fee - walletFee;\n', '\n', '        if (walletFee > 0) {\n', '            reserveFeeToWallet[reserve][wallet] += walletFee;\n', '            AssignFeeToWallet(reserve, wallet, walletFee);\n', '        }\n', '\n', '        if (feeToBurn > 0) {\n', '            AssignBurnFees(reserve, feeToBurn);\n', '            reserveFeeToBurn[reserve] += feeToBurn;\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    // this function is callable by anyone\n', '    event BurnAssignedFees(address indexed reserve, address sender);\n', '\n', '    function burnReserveFees(address reserve) public {\n', '        uint burnAmount = reserveFeeToBurn[reserve];\n', '        require(burnAmount > 1);\n', '        reserveFeeToBurn[reserve] = 1; // leave 1 twei to avoid spikes in gas fee\n', '        require(knc.burnFrom(reserveKNCWallet[reserve], burnAmount - 1));\n', '\n', '        BurnAssignedFees(reserve, msg.sender);\n', '    }\n', '\n', '    event SendWalletFees(address indexed wallet, address reserve, address sender);\n', '\n', '    // this function is callable by anyone\n', '    function sendFeeToWallet(address wallet, address reserve) public {\n', '        uint feeAmount = reserveFeeToWallet[reserve][wallet];\n', '        require(feeAmount > 1);\n', '        reserveFeeToWallet[reserve][wallet] = 1; // leave 1 twei to avoid spikes in gas fee\n', '        require(knc.transferFrom(reserveKNCWallet[reserve], wallet, feeAmount - 1));\n', '\n', '        SendWalletFees(wallet, reserve, msg.sender);\n', '    }\n', '}']