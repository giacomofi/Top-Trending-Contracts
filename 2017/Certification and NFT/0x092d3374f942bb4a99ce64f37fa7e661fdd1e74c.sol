['pragma solidity ^0.4.17;\n', '\n', '//Developed by Zenos Pavlakou\n', '\n', 'library SafeMath {\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', 'contract Ownable {\n', '    \n', '    address public owner;\n', '\n', '    /**\n', '     * The address whcih deploys this contrcat is automatically assgined ownership.\n', '     * */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * Functions with this modifier can only be executed by the owner of the contract. \n', '     * */\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '}\n', '\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) constant public returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) constant public returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public  returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'contract BasicToken is ERC20Basic, Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    modifier onlyPayloadSize(uint size) {\n', '        if (msg.data.length < size + 4) {\n', '        revert();\n', '        }\n', '        _;\n', '    }\n', '\n', '    /**\n', "     * Transfers ACO tokens from the sender's account to another given account.\n", '     * \n', '     * @param _to The address of the recipient.\n', '     * @param _amount The amount of tokens to send.\n', '     * */\n', '    function transfer(address _to, uint256 _amount) public onlyPayloadSize(2 * 32) returns (bool) {\n', '        require(balances[msg.sender] >= _amount);\n', '        balances[msg.sender] = balances[msg.sender].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Returns the balance of a given address.\n', '     * \n', '     * @param _addr The address of the balance to query.\n', '     **/\n', '    function balanceOf(address _addr) public constant returns (uint256) {\n', '        return balances[_addr];\n', '    }\n', '}\n', '\n', '\n', 'contract AdvancedToken is BasicToken, ERC20 {\n', '\n', '    mapping (address => mapping (address => uint256)) allowances;\n', '\n', '    /**\n', '     * Transfers tokens from the account of the owner by an approved spender. \n', '     * The spender cannot spend more than the approved amount. \n', '     * \n', '     * @param _from The address of the owners account.\n', '     * @param _amount The amount of tokens to transfer.\n', '     * */\n', '    function transferFrom(address _from, address _to, uint256 _amount) public onlyPayloadSize(3 * 32) returns (bool) {\n', '        require(allowances[_from][msg.sender] >= _amount && balances[_from] >= _amount);\n', '        allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_amount);\n', '        balances[_from] = balances[_from].sub(_amount);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Allows another account to spend a given amount of tokens on behalf of the \n', "     * owner's account. If the owner has previously allowed a spender to spend\n", '     * tokens on his or her behalf and would like to change the approval amount,\n', '     * he or she will first have to set the allowance back to 0 and then update\n', '     * the allowance.\n', '     * \n', '     * @param _spender The address of the spenders account.\n', '     * @param _amount The amount of tokens the spender is allowed to spend.\n', '     * */\n', '    function approve(address _spender, uint256 _amount) public returns (bool) {\n', '        require((_amount == 0) || (allowances[msg.sender][_spender] == 0));\n', '        allowances[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    /**\n', '     * Returns the approved allowance from an owners account to a spenders account.\n', '     * \n', '     * @param _owner The address of the owners account.\n', '     * @param _spender The address of the spenders account.\n', '     **/\n', '    function allowance(address _owner, address _spender) public constant returns (uint256) {\n', '        return allowances[_owner][_spender];\n', '    }\n', '}\n', '\n', '\n', 'contract MintableToken is AdvancedToken {\n', '\n', '    bool public mintingFinished;\n', '\n', '    event TokensMinted(address indexed to, uint256 amount);\n', '    event MintingFinished();\n', '\n', '    /**\n', '     * Generates new ACO tokens during the ICO, after which the minting period \n', '     * will terminate permenantly. This function can only be called by the ICO \n', '     * contract.\n', '     * \n', '     * @param _to The address of the account to mint new tokens to.\n', '     * @param _amount The amount of tokens to mint. \n', '     * */\n', '    function mint(address _to, uint256 _amount) external onlyOwner onlyPayloadSize(2 * 32) returns (bool) {\n', '        require(_to != 0x0 && _amount > 0 && !mintingFinished);\n', '        balances[_to] = balances[_to].add(_amount);\n', '        totalSupply = totalSupply.add(_amount);\n', '        Transfer(0x0, _to, _amount);\n', '        TokensMinted(_to, _amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Terminates the minting period permenantly. This function can only be called\n', '     * by the ICO contract only when the duration of the ICO has ended. \n', '     * */\n', '    function finishMinting() external onlyOwner {\n', '        require(!mintingFinished);\n', '        mintingFinished = true;\n', '        MintingFinished();\n', '    }\n', '    \n', '    /**\n', '     * Returns true if the minting period has ended, false otherwhise.\n', '     * */\n', '    function mintingFinished() public constant returns (bool) {\n', '        return mintingFinished;\n', '    }\n', '}\n', '\n', '\n', 'contract ACO is MintableToken {\n', '\n', '    uint8 public decimals;\n', '    string public name;\n', '    string public symbol;\n', '\n', '    function ACO() public {\n', '        totalSupply = 0;\n', '        decimals = 18;\n', '        name = "ACO";\n', '        symbol = "ACO";\n', '    }\n', '}\n', '\n', '\n', 'contract MultiOwnable {\n', '    \n', '    address[2] public owners;\n', '\n', '    event OwnershipTransferred(address from, address to);\n', '    event OwnershipGranted(address to);\n', '\n', '    function MultiOwnable() public {\n', '        owners[0] = 0x1d554c421182a94E2f4cBD833f24682BBe1eeFe8; //R1\n', '        owners[1] = 0x0D7a2716466332Fc5a256FF0d20555A44c099453; //R2\n', '    }\n', '\n', '    /**\n', '     * Functions with this modifier will only execute if the the function is called by the \n', '     * owners of the contract.\n', '     * */ \n', '    modifier onlyOwners {\n', '        require(msg.sender == owners[0] || msg.sender == owners[1]);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * Trasfers ownership from the owner who executes the function to another given address.\n', '     * \n', '     * @param _newOwner The address which will be granted ownership.\n', '     * */\n', '    function transferOwnership(address _newOwner) public onlyOwners {\n', '        require(_newOwner != 0x0 && _newOwner != owners[0] && _newOwner != owners[1]);\n', '        if (msg.sender == owners[0]) {\n', '            OwnershipTransferred(owners[0], _newOwner);\n', '            owners[0] = _newOwner;\n', '        } else {\n', '            OwnershipTransferred(owners[1], _newOwner);\n', '            owners[1] = _newOwner;\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract Crowdsale is MultiOwnable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    ACO public ACO_Token;\n', '\n', '    address public constant MULTI_SIG = 0x3Ee28dA5eFe653402C5192054064F12a42EA709e;\n', '\n', '    bool public success;\n', '    uint256 public rate;\n', '    uint256 public rateWithBonus;\n', '    uint256 public tokensSold;\n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '    uint256 public minimumGoal;\n', '    uint256 public cap;\n', '    uint256[4] private bonusStages;\n', '\n', '    mapping (address => uint256) investments;\n', '    mapping (address => bool) hasAuthorizedWithdrawal;\n', '\n', '    event TokensPurchased(address indexed by, uint256 amount);\n', '    event RefundIssued(address indexed by, uint256 amount);\n', '    event FundsWithdrawn(address indexed by, uint256 amount);\n', '    event IcoSuccess();\n', '    event CapReached();\n', '\n', '    function Crowdsale() public {\n', '        ACO_Token = new ACO();\n', '        minimumGoal = 3000 ether;\n', '        cap = 87500 ether;\n', '        rate = 4000;\n', '        startTime = now.add(3 days);\n', '        endTime = startTime.add(90 days);\n', '        bonusStages[0] = startTime.add(14 days);\n', '\n', '        for (uint i = 1; i < bonusStages.length; i++) {\n', '            bonusStages[i] = bonusStages[i - 1].add(14 days);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Fallback function calls the buyTokens function when ETH is sent to this \n', '     * contact.\n', '     * */\n', '    function() public payable {\n', '        buyTokens(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * Allows investors to buy ACO tokens. Once ETH is sent to this contract, \n', '     * the investor will automatically receive tokens. \n', '     * \n', '     * @param _beneficiary The address the newly minted tokens will be sent to.\n', '     * */\n', '    function buyTokens(address _beneficiary) public payable {\n', '        require(_beneficiary != 0x0 && validPurchase() && weiRaised().sub(msg.value) < cap);\n', '        if (this.balance >= minimumGoal && !success) {\n', '            success = true;\n', '            IcoSuccess();\n', '        }\n', '        uint256 weiAmount = msg.value;\n', '        if (this.balance > cap) {\n', '            CapReached();\n', '            uint256 toRefund = this.balance.sub(cap);\n', '            msg.sender.transfer(toRefund);\n', '            weiAmount = weiAmount.sub(toRefund);\n', '        }\n', '        uint256 tokens = weiAmount.mul(getCurrentRateWithBonus());\n', '        ACO_Token.mint(_beneficiary, tokens);\n', '        tokensSold = tokensSold.add(tokens);\n', '        investments[_beneficiary] = investments[_beneficiary].add(weiAmount);\n', '        TokensPurchased(_beneficiary, tokens);\n', '    }\n', '\n', '    /**\n', '     * Returns the amount of tokens 1 ETH equates to with the bonus percentage.\n', '     * */\n', '    function getCurrentRateWithBonus() public returns (uint256) {\n', '        rateWithBonus = (rate.mul(getBonusPercentage()).div(100)).add(rate);\n', '        return rateWithBonus;\n', '    }\n', '\n', '    /**\n', '     * Calculates and returns the bonus percentage based on how early an investment\n', '     * is made. If ETH is sent to the contract after the bonus period, the bonus \n', '     * percentage will default to 0\n', '     * */\n', '    function getBonusPercentage() internal view returns (uint256 bonusPercentage) {\n', '        uint256 timeStamp = now;\n', '        if (timeStamp > bonusStages[3]) {\n', '            bonusPercentage = 0;\n', '        } else { \n', '            bonusPercentage = 25;\n', '            for (uint i = 0; i < bonusStages.length; i++) {\n', '                if (timeStamp <= bonusStages[i]) {\n', '                    break;\n', '                } else {\n', '                    bonusPercentage = bonusPercentage.sub(5);\n', '                }\n', '            }\n', '        }\n', '        return bonusPercentage;\n', '    }\n', '\n', '    /**\n', '     * Returns the current rate 1 ETH equates to including the bonus amount. \n', '     * */\n', '    function currentRate() public constant returns (uint256) {\n', '        return rateWithBonus;\n', '    }\n', '\n', '    /**\n', '     * Checks whether an incoming transaction from the buyTokens function is \n', '     * valid or not. For a purchase to be valid, investors have to buy tokens\n', '     * only during the ICO period and the value being transferred must be greater\n', '     * than 0.\n', '     * */\n', '    function validPurchase() internal constant returns (bool) {\n', '        bool withinPeriod = now >= startTime && now <= endTime;\n', '        bool nonZeroPurchase = msg.value != 0;\n', '        return withinPeriod && nonZeroPurchase;\n', '    }\n', '    \n', '    /**\n', '     * Issues a refund to a given address. This function can only be called if\n', '     * the duration of the ICO has ended and the minimum goal has not been reached.\n', '     * \n', '     * @param _addr The address that will receive a refund. \n', '     * */\n', '    function getRefund(address _addr) public {\n', '        if (_addr == 0x0) {\n', '            _addr = msg.sender;\n', '        }\n', '        require(!isSuccess() && hasEnded() && investments[_addr] > 0);\n', '        uint256 toRefund = investments[_addr];\n', '        investments[_addr] = 0;\n', '        _addr.transfer(toRefund);\n', '        RefundIssued(_addr, toRefund);\n', '    }\n', '\n', '    /**\n', '     * This function can only be called by the onwers of the ICO contract. There \n', '     * needs to be 2 approvals, one from each owner. Once two approvals have been \n', '     * made, the funds raised will be sent to a multi signature wallet. This \n', '     * function cannot be called if the ICO is not a success.\n', '     * */\n', '    function authorizeWithdrawal() public onlyOwners {\n', '        require(hasEnded() && isSuccess() && !hasAuthorizedWithdrawal[msg.sender]);\n', '        hasAuthorizedWithdrawal[msg.sender] = true;\n', '        if (hasAuthorizedWithdrawal[owners[0]] && hasAuthorizedWithdrawal[owners[1]]) {\n', '            FundsWithdrawn(owners[0], this.balance);\n', '            MULTI_SIG.transfer(this.balance);\n', '        }\n', '    }\n', '    \n', '    /**\n', '     * Generates newly minted ACO tokens and sends them to a given address. This \n', '     * function can only be called by the owners of the ICO contract during the \n', '     * minting period.\n', '     * \n', '     * @param _to The address to mint new tokens to.\n', '     * @param _amount The amount of tokens to mint.\n', '     * */\n', '    function issueBounty(address _to, uint256 _amount) public onlyOwners {\n', '        require(_to != 0x0 && _amount > 0);\n', '        ACO_Token.mint(_to, _amount);\n', '    }\n', '    \n', '    /**\n', '     * Terminates the minting period permanently. This function can only be \n', '     * executed by the owners of the ICO contract. \n', '     * */\n', '    function finishMinting() public onlyOwners {\n', '        require(hasEnded());\n', '        ACO_Token.finishMinting();\n', '    }\n', '\n', '    /**\n', '     * Returns the minimum goal of the ICO.\n', '     * */\n', '    function minimumGoal() public constant returns (uint256) {\n', '        return minimumGoal;\n', '    }\n', '\n', '    /**\n', '     * Returns the maximum amount of funds the ICO can receive.\n', '     * */\n', '    function cap() public constant returns (uint256) {\n', '        return cap;\n', '    }\n', '\n', '    /**\n', '     * Returns the time that the ICO duration will end.\n', '     * */\n', '    function endTime() public constant returns (uint256) {\n', '        return endTime;\n', '    }\n', '\n', '    /**\n', '     * Returns the amount of ETH a given address has invested.\n', '     * \n', '     * @param _addr The address to query the investment of. \n', '     * */\n', '    function investmentOf(address _addr) public constant returns (uint256) {\n', '        return investments[_addr];\n', '    }\n', '\n', '    /**\n', '     * Returns true if the duration of the ICO is over.\n', '     * */\n', '    function hasEnded() public constant returns (bool) {\n', '        return now > endTime;\n', '    }\n', '\n', '    /**\n', '     * Returns true if the ICO is a success.\n', '     * */\n', '    function isSuccess() public constant returns (bool) {\n', '        return success;\n', '    }\n', '\n', '    /**\n', '     * Returns the amount of ETH raised in wei.\n', '     * */\n', '    function weiRaised() public constant returns (uint256) {\n', '        return this.balance;\n', '    }\n', '}']