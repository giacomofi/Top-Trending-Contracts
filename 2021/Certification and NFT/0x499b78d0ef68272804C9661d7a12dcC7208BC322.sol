['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-29\n', '*/\n', '\n', '/*****************************\n', '\n', '** PROOF UTILITY TOKEN (PRF) **\n', '   Developed by @cryptocreater\n', '   Produced by PROOF CAPITAL GROUP\n', '\n', '** TOKEN INFO **\n', '   Name:     PROOF UTILITY\n', '   Code:     PRF\n', '   Decimals: 6\n', '\n', '** PRF TOKEN MARKETING **\n', '   1. The maximum emission of the PROOF UTILITY token is 1 000 000 000 PRF.\n', '   2. Initial emission of PROOF UTILITY token to replace PROOF TOKEN - 350 000 PRF.\n', '   3. Renumeration for the founders of the PRF (bounty) - 1% of the total emission of PRF (accrued as the release of PRF tokens).\n', '   4. The minimum balance to receive a staking profit is 10 PRF.\n', '   5. The maximum balance for receiving staking profit is 999 999 PRF.\n', '   6. The profit for holding the token, depending on the balance, per 1 day is: from 10 PRF - 0.10%, from 100 PRF - 0.13%, from 500 PRF - 0.17%, from 1 000 PRF - 0.22%, from 5 000 PRF - 0.28%, from 10 000 PRF - 0.35%, from 50 000 PRF - 0.43%, from 100 000 PRF - 0.52%, from 500 000 PRF - 0.62% and is fixed per second for each transaction at the address, excluding the PROOF ASSET smart contract profit, which receives a reward of 0.62% regardless of the amount of the balance.\n', '   7. When transferring PRF to an address that has not previously received PRF tokens, this address becomes a follower (referral) of the address from which the PRFs were received (referrer).\n', '   8. When calculating a profit for a referral, the referrer receives a referral reward from the amount received by the referral for holding the PRF token.\n', '   9. The minimum balance to receive a referral reward is 100 PRF.\n', '  10. The maximum balance for receiving a referral reward is 1 000 000 PRF.\n', '  11. Referral reward is calculated from the amount of the referral profit and depends on the referrer balance: from 100 PRF - 5.2%, from 1 000 PRF - 7.5%, from 10 000 PRF - 12.8%, from 100 000 PRF - 26.5%.\n', "  12. When calculating all types of profits and rewards, the rule of complication applies, which reduces the income by the percentage of the current supply of the PRF token to it's maximum supply.\n", '\n', '** PRF TOKEN MECHANICS **\n', '   1. To receive PRF tokens, you need to send the required number of ETH tokens to the address of the PROOF UTILITY smart contract.\n', '   2. The smart contract issues the required number of PRF tokens to the address from which the ETH tokens came according to the average exchange rate of the UNISWAP exchange in the equivalent of ETH to stable coins equivalent to the equivalent of 1 USD.\n', '   3. To fix the reward and withdraw it to the address, it is necessary to send a zero transaction (0 PRF or 0 ETH) from the address to itself.\n', '   4. To bind a follower (referral), you need to send any number of PRF tokens to its address. The referral will be linked only if he has not previously been linked to another address.\n', '   5. The administrator of the smart contract can, without warning and at his own discretion, stop and start the exchange of ETH for PRF on the smart contract, while the process of calculating rewards and profits for existing tokens does not stop.\n', '   6. To exchange PRF for a PRS token, send PRF to the PROOF ASSET smart contract address to register the exchange and wait for submission of this operation, then send 0 (zero) ETH to the PROOF ASSET smart contract address from the same address to credit PRS tokens to it.\n', '   7. The initial minimum amount of exchanging a PRF token for a PRS token is 1 (one) PRS or 1 000 (one thousand) PRF and can be reduced without warning and at the discretion of the administrator of the PROOF UTILITY smart contract without the possibility of further increase.\n', '   8. The administrator of the smart contract can, without warning and at his discretion, raise and lower the exchange rate multiply of ETH tokens for PRF tokens, but not less than 1 PRF to the equivalent of 1 USD.\n', '\n', '*****************************/\n', '\n', 'pragma solidity 0.6.6;\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 amount);\n', '    event Approval(address indexed owner, address indexed spender, uint256 amount);\n', '    event Swap(address indexed account, uint256 amount);\n', '    event Swaped(address indexed account, uint256 amount);\n', '}\n', 'interface EthRateInterface {\n', '    function EthToUsdRate() external view returns(uint256);\n', '}\n', 'library SafeMath {\n', '    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(a + b >= a, "Addition overflow");\n', '        return a + b;\n', '    }\n', '    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(a >= b, "Substruction overflow");\n', '        return a - b;\n', '    }  \n', '}\n', 'contract ERC20 is IERC20 {\n', '    using SafeMath for uint256;\n', '    mapping (address => uint256) private _balances;    \n', '    mapping (address => uint256) private _sto;\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '    uint256 private _totalSupply;\n', '    string private _name = "PROOF UTILITY";\n', '    string private _symbol = "PRF";\n', '    uint8 private _decimals = 6;\n', '    function name() public view returns (string memory) { return _name; }    \n', '    function symbol() public view returns (string memory) { return _symbol; }    \n', '    function decimals() public view returns (uint8) { return _decimals; }\n', '    function totalSupply() public view override returns (uint256) { return _totalSupply; }\n', '    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }\n', '    function swapOf(address account) public view returns (uint256) { return _sto[account]; }\n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) { return _allowances[owner][spender]; }\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _afterTransferFrom(sender, recipient, amount);\n', '        _approve(sender, msg.sender, _allowances[sender][msg.sender].safeSub(amount));\n', '        return true;\n', '    }\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].safeAdd(addedValue));\n', '        return true;\n', '    }\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        _approve(msg.sender, spender, _allowances[msg.sender][spender].safeSub(subtractedValue));\n', '        return true;\n', '    }\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "Zero address");\n', '        require(recipient != address(0), "Zero address");\n', '        _beforeTokenTransfer(sender, recipient, amount);\n', '        _balances[sender] = _balances[sender].safeSub(amount);\n', '        _balances[recipient] = _balances[recipient].safeAdd(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "Zero account");\n', '        _beforeTokenTransfer(address(0), account, amount);\n', '        _totalSupply = _totalSupply.safeAdd(amount);\n', '        _balances[account] = _balances[account].safeAdd(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "Zero account");\n', '        _beforeTokenTransfer(account, address(0), amount);\n', '        _balances[account] = _balances[account].safeSub(amount);\n', '        _totalSupply = _totalSupply.safeSub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "Zero owner");\n', '        require(spender != address(0), "Zero spender");\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '    function _swap(address account, uint256 amount) internal virtual {\n', '        require (amount > 0, "Zero amount");\n', '        _sto[account] = _sto[account].safeAdd(amount);\n', '        emit Swap(account, amount);\n', '    }\n', '    function _swaped(address account, uint256 amount) internal virtual {\n', '        _sto[account] = _sto[account].safeSub(amount);\n', '        emit Swaped(account, amount);\n', '    }\n', '    function _setupDecimals(uint8 decimals_) internal {\n', '        _decimals = decimals_;\n', '    }\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }    \n', '    function _afterTransferFrom(address sender, address recipient, uint256 amount) internal virtual { }\n', '}\n', 'contract ProofUtilityToken is ERC20 {\n', '    using SafeMath for uint256;\n', '    bool public sales = true;\n', '    address private insurance;\n', '    address private smart;\n', '    address public stoContract = address(0);\n', '    address[] private founders;\n', '    mapping(address => address) private referrers;\n', '    mapping(address => uint64) private fixes;\n', '    mapping(address => uint256) private holds;\n', '    uint256 public multiply = 100;\n', '    uint256 public minimum = 1e9;\n', '    uint256 private bounted = 35e12;\n', '    EthRateInterface public EthRateSource = EthRateInterface(0xf1401D5493D257cb7FECE1309B221e186c5b69f9);\n', '    event Payout(address indexed account, uint256 amount);\n', '    event CheckIn(address indexed account, uint256 amount, uint256 value);\n', '    event Profit(address indexed account, uint256 amount);\n', '    event Reward(address indexed account, uint256 amount);\n', '    event NewMultiply(uint256 value);\n', '    event NewMinimum(uint256 value);\n', '    modifier onlyFounders() {\n', '        for(uint256 i = 0; i < founders.length; i++) {\n', '            if(founders[i] == msg.sender) {\n', '                _;\n', '                return;\n', '            }\n', '        }\n', '        revert("Access denied");\n', '    }\n', '    constructor() public {\n', '        smart = address(this);\n', '        referrers[smart] = smart;\n', '        insurance = 0x4141a692Ae0b49Ed22e961526755B8CC9Aa65139;\n', '        referrers[0x4141a692Ae0b49Ed22e961526755B8CC9Aa65139] = smart;\n', '        founders.push(0x30517CaE41977fc9d4a21e2423b7D5Ce8D19d0cb);\n', '        referrers[0x30517CaE41977fc9d4a21e2423b7D5Ce8D19d0cb] = smart;\n', '        founders.push(0x2589171E72A4aaa7b0e7Cc493DB6db7e32aC97d4);\n', '        referrers[0x2589171E72A4aaa7b0e7Cc493DB6db7e32aC97d4] = smart;\n', '        founders.push(0x3d027e252A275650643cE83934f492B6914D3341);\n', '        referrers[0x3d027e252A275650643cE83934f492B6914D3341] = smart;\n', '        _mint(0x7c726AC69461e772F975c3212Db5d7cb57352CA2, 35e10);\n', '    }\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {\n', '        if(to == stoContract) {\n', '            require(amount >= minimum, "Little amount");\n', '            _swap(from, amount);\n', '        }\n', '        if(referrers[to] == address(0) && amount > 0 && from != address(0)) referrers[to] = from;\n', '        uint256 _supply = totalSupply();\n', '        if(from == to) {\n', '            _payout(from, _supply);\n', '        } else {\n', '            if(_supply < 1e15) {\n', '                if(from != address(0)) {\n', '                    uint256 _profit = _fixProfit(from, _supply);\n', '                    if(_profit > 0) _fixReward(referrers[from], _profit, _supply);\n', '                }\n', '                if(to != address(0)) {\n', '                    if(fixes[to] > 0) {\n', '                        uint256 _profit = _fixProfit(to, _supply);\n', '                        if(_profit > 0) _fixReward(referrers[to], _profit, _supply);\n', '                    } else fixes[to] = uint64(block.timestamp);\n', '                }\n', '            }\n', '        }\n', '    }\n', '    function _afterTransferFrom(address sender, address recipient, uint256 amount) internal override { if(recipient == stoContract) _swaped(sender, amount); }\n', '    function _fixProfit(address account, uint256 supply) private returns(uint256 _value) {\n', '        uint256 _balance = balanceOf(account);\n', '        uint256 _hold = block.timestamp - fixes[account];\n', '        uint256 _percent;\n', '        _value = 0;\n', '        if(_hold > 0) {\n', '            if(_balance > 1e7) {\n', '                if(account == stoContract) _percent = 62;\n', '                else if(_balance < 1e8) _percent = 10;\n', '                else if(_balance < 5e8) _percent = 13;\n', '                else if(_balance < 1e9) _percent = 17;\n', '                else if(_balance < 5e9) _percent = 22;\n', '                else if(_balance < 1e10) _percent = 28;\n', '                else if(_balance < 5e10) _percent = 35;\n', '                else if(_balance < 1e11) _percent = 43;\n', '                else if(_balance < 5e11) _percent = 52;\n', '                else if(_balance < 1e12) _percent = 62;\n', '                else _percent = 0;\n', '                if(_percent > 0) {\n', '                    _value = _hold * _balance * _percent / 864 / 1e6;\n', '                    uint256 tax = _value * supply / 1e15;\n', '                    _value = _value.safeSub(tax);\n', '                    holds[account] = holds[account].safeAdd(_value);\n', '                    fixes[account] = uint64(block.timestamp);\n', '                    emit Profit(account, _value);\n', '                }\n', '            }\n', '        }        \n', '    }\n', '    function _fixReward(address referrer, uint256 amount, uint256 supply) private returns(uint256 _value) {\n', '        uint256 _balance = balanceOf(referrer);\n', '        uint256 _percent;\n', '        if(_balance >= 1e8 && _balance < 1e12) {\n', '            if (_balance < 1e9) _percent = 520;\n', '            else if(_balance < 1e10) _percent = 750;\n', '            else if(_balance < 1e11) _percent = 1280;\n', '            else _percent = 2650;\n', '            _value = amount * _percent / 10000;\n', '            uint256 tax = _value * supply / 1e15;\n', '            _value = _value.safeSub(tax);\n', '            holds[referrer] = holds[referrer].safeAdd(_value);\n', '            emit Reward(referrer, _value);\n', '        }\n', '    }\n', '    function _payout(address account, uint256 supply) private {\n', '        require(supply < 1e15, "Emition is closed");\n', '        uint256 _profit = _fixProfit(account, supply);\n', '        if(_profit > 0) _fixReward(referrers[account], _profit, supply);\n', '        uint256 _userProfit = holds[account];\n', '        _userProfit = supply + _userProfit > 1e15 ? 1e15 - supply : _userProfit;\n', '        if(_userProfit > 0) {\n', '            holds[account] = 0;\n', '            _mint(account, _userProfit);\n', '            emit Payout(account, _userProfit);\n', '        }\n', '    }\n', '    receive() payable external {\n', '        uint256 _supply = totalSupply();\n', '        require(_supply < 1e15, "Sale finished");\n', '        if(msg.value > 0) {\n', '            require(sales, "Sale deactivated");\n', '            if(referrers[msg.sender] == address(0)) referrers[msg.sender] = smart;\n', '            uint256 _rate = EthRateSource.EthToUsdRate();\n', '            require(_rate > 0, "Rate error");\n', '            uint256 _amount = msg.value * _rate * 100 / multiply / 1e18;\n', '            if(_supply + _amount > 1e15) _amount = 1e15 - _supply;\n', '            _mint(msg.sender, _amount);\n', '            emit CheckIn(msg.sender, msg.value, _amount);\n', '        } else {\n', '            require(fixes[msg.sender] > 0, "No profit");\n', '            _payout(msg.sender, _supply);\n', '        }\n', '    }\n', '    function fnSales() external onlyFounders {\n', '        if(sales) sales = false;\n', '        else sales = true;\n', '    }\n', '    function fnFounder(address account) external onlyFounders {\n', '        for(uint8 i = 0; i < 3; i++) {\n', '            if(founders[i] == msg.sender) founders[i] = account;\n', '        }\n', '    }\n', '    function fnInsurance(address account) external onlyFounders { insurance = account; }\n', '    function fnSource(address source) external onlyFounders {\n', '        EthRateSource = EthRateInterface(source);\n', '    }\n', '    function fnSto(address source) external onlyFounders {\n', '        require(stoContract == address(0), "Already indicated");\n', '        stoContract = source;\n', '        referrers[stoContract] = smart;\n', '    }\n', '    function fnMinimum(uint256 value) external onlyFounders {\n', '        require(minimum > value, "Big value");\n', '        minimum = value;\n', '        emit NewMinimum(value);\n', '    }\n', '    function fnMultiply(uint256 value) external onlyFounders {\n', '        require(value >= 100, "Wrong multiply");\n', '        multiply = value;\n', '        emit NewMultiply(value);\n', '    }\n', '    function fnProfit(address account) external {\n', '        require(fixes[account] > 0 && holds[account] + balanceOf(account) > 0, "No profit");\n', '        _payout(account, totalSupply());\n', '    }\n', '    function fnSwap(address account, uint256 amount) external {\n', '        require(msg.sender == stoContract, "Access denied");\n', '        _swaped(account, amount);\n', '    }\n', '    function fnProof(bool all) external {\n', '        uint256 _amount = all ? balanceOf(smart) : balanceOf(smart).safeSub(1e9);\n', '        require(_amount >= 3, "Little amount");\n', '        for(uint8 i = 0; i < 3; i++) { _transfer(smart, founders[i], _amount / founders.length); }        \n', '    }\n', '    function fnBounty() external {\n', '        uint256 _delta = totalSupply().safeSub(bounted);\n', '        uint256 _bounty = _delta / 100;\n', '        require(_bounty >= 3, "Little amount");\n', '        bounted = bounted.safeAdd(_delta);\n', '        for(uint8 i = 0; i < 3; i++) { _mint(founders[i], _bounty / 3); }\n', '    }\n', '    function fnEth() external {\n', '        uint256 _amount = smart.balance;\n', '        require(_amount >= 10, "Little amount");\n', '        payable(insurance).transfer(_amount / 10);\n', '        for(uint8 i = 0; i < 3; i++) { payable(founders[i]).transfer(_amount * 3 / 10); }\n', '    }\n', '    function fnBurn(uint256 amount) external { _burn(msg.sender, amount); }\n', '    function showRate() external view returns(uint256) { return EthRateSource.EthToUsdRate(); }\n', '    function showTax() external view returns(uint256) { return totalSupply() / 1e13; }\n', '    function showUser(address account) external view returns(address referrer, uint256 balance, uint256 fix, uint256 profit) { return (referrers[account], balanceOf(account), fixes[account], holds[account]); }\n', '}']