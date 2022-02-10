['pragma solidity ^0.4.18;\n', '\n', '// ----------------------------------------------------------------------------\n', '// &#39;ADE&#39; &#39;AdeCoin&#39; token contract\n', '//\n', '// Symbol      : ADE\n', '// Name        : AdeCoin\n', '// Total supply: Generated from contributions\n', '// Decimals    : 8\n', '//\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function safeDiv(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event TransferSell(address indexed from, uint tokens, uint eth);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '//\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals\n', '// Receives ETH and generates tokens\n', '// ----------------------------------------------------------------------------\n', 'contract ADEToken is ERC20Interface, Owned, SafeMath {\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '    uint public totalSupply;\n', '    uint public sellRate;\n', '    uint public buyRate;\n', '    \n', '    uint private lockRate = 30 days;\n', '    \n', '    struct lockPosition{\n', '        uint time;\n', '        uint count;\n', '        uint releaseRate;\n', '    }\n', '    \n', '    mapping(address => lockPosition) private lposition;\n', '    \n', '    // locked account dictionary that maps addresses to boolean\n', '    mapping (address => bool) private lockedAccounts;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    \n', '    modifier is_not_locked(address _address) {\n', '        if (lockedAccounts[_address] == true) revert();\n', '        _;\n', '    }\n', '    \n', '    modifier validate_address(address _address) {\n', '        if (_address == address(0)) revert();\n', '        _;\n', '    }\n', '    \n', '    modifier is_locked(address _address) {\n', '        if (lockedAccounts[_address] != true) revert();\n', '        _;\n', '    }\n', '    \n', '    modifier validate_position(address _address,uint count) {\n', '        if(balances[_address] < count * 10**uint(decimals)) revert();\n', '        if(lposition[_address].count > 0 && (balances[_address] - (count * 10**uint(decimals))) < lposition[_address].count && now < lposition[_address].time) revert();\n', '        checkPosition(_address,count);\n', '        _;\n', '    }\n', '    function checkPosition(address _address,uint count) private view {\n', '        if(lposition[_address].releaseRate < 100 && lposition[_address].count > 0){\n', '            uint _rate = safeDiv(100,lposition[_address].releaseRate);\n', '            uint _time = lposition[_address].time;\n', '            uint _tmpRate = lposition[_address].releaseRate;\n', '            uint _tmpRateAll = 0;\n', '            uint _count = 0;\n', '            for(uint _a=1;_a<=_rate;_a++){\n', '                if(now >= _time){\n', '                    _count = _a;\n', '                    _tmpRateAll = safeAdd(_tmpRateAll,_tmpRate);\n', '                    _time = safeAdd(_time,lockRate);\n', '                }\n', '            }\n', '            if(_count < _rate && lposition[_address].count > 0 && (balances[_address] - count * 10**uint(decimals)) < (lposition[_address].count - safeDiv(lposition[_address].count*_tmpRateAll,100)) && now >= lposition[_address].time) revert();   \n', '        }\n', '    }\n', '    \n', '    event _lockAccount(address _add);\n', '    event _unlockAccount(address _add);\n', '    \n', '    function () public payable{\n', '        require(owner != msg.sender);\n', '        require(buyRate > 0);\n', '        \n', '        require(msg.value >= 0.1 ether && msg.value <= 1000 ether);\n', '        uint tokens;\n', '        \n', '        tokens = msg.value / (1 ether * 1 wei / buyRate);\n', '        \n', '        \n', '        require(balances[owner] >= tokens * 10**uint(decimals));\n', '        balances[msg.sender] = safeAdd(balances[msg.sender], tokens * 10**uint(decimals));\n', '        balances[owner] = safeSub(balances[owner], tokens * 10**uint(decimals));\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function ADEToken(uint _sellRate,uint _buyRate) public payable {\n', '        symbol = "ADE";\n', '        name = "AdeCoin";\n', '        decimals = 8;\n', '        totalSupply = 2000000000 * 10**uint(decimals);\n', '        balances[owner] = totalSupply;\n', '        Transfer(address(0), owner, totalSupply);\n', '        sellRate = _sellRate;\n', '        buyRate = _buyRate;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return totalSupply  - balances[address(0)];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer the balance from token owner&#39;s account to `to` account\n', '    // - Owner&#39;s account must have sufficient balance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public is_not_locked(msg.sender) is_not_locked(to) validate_position(msg.sender,tokens / (10**uint(decimals))) returns (bool success) {\n', '        require(to != msg.sender);\n', '        require(tokens > 0);\n', '        require(balances[msg.sender] >= tokens);\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account\n', '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public is_not_locked(msg.sender) is_not_locked(spender) validate_position(msg.sender,tokens / (10**uint(decimals))) returns (bool success) {\n', '        require(spender != msg.sender);\n', '        require(tokens > 0);\n', '        require(balances[msg.sender] >= tokens);\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public is_not_locked(msg.sender) is_not_locked(from) is_not_locked(to) validate_position(from,tokens / (10**uint(decimals))) returns (bool success) {\n', '        require(transferFromCheck(from,to,tokens));\n', '        return true;\n', '    }\n', '    \n', '    function transferFromCheck(address from,address to,uint tokens) private returns (bool success) {\n', '        require(tokens > 0);\n', '        require(from != msg.sender && msg.sender != to && from != to);\n', '        require(balances[from] >= tokens && allowed[from][msg.sender] >= tokens);\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', '    // transferred to the spender&#39;s account\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', '    // from the token owner&#39;s account. The `spender` contract function\n', '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '    \n', '\n', '    // ------------------------------------------------------------------------\n', '    // Sall a token from a contract\n', '    // ------------------------------------------------------------------------\n', '    function sellCoin(address seller, uint amount) public onlyOwner is_not_locked(seller) validate_position(seller,amount){\n', '        require(balances[seller] >= amount * 10**uint(decimals));\n', '        require(sellRate > 0);\n', '        require(seller != msg.sender);\n', '        uint tmpAmount = amount * (1 ether * 1 wei / sellRate);\n', '        \n', '        balances[owner] += amount * 10**uint(decimals);\n', '        balances[seller] -= amount * 10**uint(decimals);\n', '        \n', '        seller.transfer(tmpAmount);\n', '        TransferSell(seller, amount * 10**uint(decimals), tmpAmount);\n', '    }\n', '    \n', '    // set rate\n', '    function setRate(uint _buyRate,uint _sellRate) public onlyOwner {\n', '        require(_buyRate > 0);\n', '        require(_sellRate > 0);\n', '        require(_buyRate < _sellRate);\n', '        buyRate = _buyRate;\n', '        sellRate = _sellRate;\n', '    }\n', '    \n', '    //set lock position\n', '    function setLockPostion(address _add,uint _count,uint _time,uint _releaseRate) public is_not_locked(_add) onlyOwner {\n', '        require(_time > now);\n', '        require(_count > 0);\n', '        require(_releaseRate > 0 && _releaseRate <= 100);\n', '        require(_releaseRate == 2 || _releaseRate == 4 || _releaseRate == 5 || _releaseRate == 10 || _releaseRate == 20 || _releaseRate == 25 || _releaseRate == 50);\n', '        require(balances[_add] >= _count * 10**uint(decimals));\n', '        lposition[_add].time = _time;\n', '        lposition[_add].count = _count * 10**uint(decimals);\n', '        lposition[_add].releaseRate = _releaseRate;\n', '    }\n', '    \n', '    // lockAccount\n', '    function lockStatus(address _owner) public is_not_locked(_owner)  validate_address(_owner) onlyOwner {\n', '        lockedAccounts[_owner] = true;\n', '        _lockAccount(_owner);\n', '    }\n', '\n', '    /// @notice only the admin is allowed to unlock accounts.\n', '    /// @param _owner the address of the account to be unlocked\n', '    function unlockStatus(address _owner) public is_locked(_owner) validate_address(_owner) onlyOwner {\n', '        lockedAccounts[_owner] = false;\n', '        _unlockAccount(_owner);\n', '    }\n', '    \n', '    //get lockedaccount\n', '    function getLockStatus(address _owner) public view returns (bool _lockStatus) {\n', '        return lockedAccounts[_owner];\n', '    }\n', '    \n', '    //get lockPosition info\n', '    function getLockPosition(address _add) public view returns(uint time,uint count,uint rate,uint scount) {\n', '        \n', '        return (lposition[_add].time,lposition[_add].count,lposition[_add].releaseRate,positionScount(_add));\n', '    }\n', '    \n', '    function positionScount(address _add) private view returns (uint count){\n', '        uint _rate = safeDiv(100,lposition[_add].releaseRate);\n', '        uint _time = lposition[_add].time;\n', '        uint _tmpRate = lposition[_add].releaseRate;\n', '        uint _tmpRateAll = 0;\n', '        for(uint _a=1;_a<=_rate;_a++){\n', '            if(now >= _time){\n', '                _tmpRateAll = safeAdd(_tmpRateAll,_tmpRate);\n', '                _time = safeAdd(_time,lockRate);\n', '            }\n', '        }\n', '        \n', '        return (lposition[_add].count - safeDiv(lposition[_add].count*_tmpRateAll,100));\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'ADE' 'AdeCoin' token contract\n", '//\n', '// Symbol      : ADE\n', '// Name        : AdeCoin\n', '// Total supply: Generated from contributions\n', '// Decimals    : 8\n', '//\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Safe maths\n', '// ----------------------------------------------------------------------------\n', 'contract SafeMath {\n', '    function safeAdd(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function safeSub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a);\n', '        c = a - b;\n', '    }\n', '    function safeMul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function safeDiv(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0);\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '    function totalSupply() public constant returns (uint);\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);\n', '    function transfer(address to, uint tokens) public returns (bool success);\n', '    function approve(address spender, uint tokens) public returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint tokens);\n', '    event TransferSell(address indexed from, uint tokens, uint eth);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Contract function to receive approval and execute function in one call\n', '//\n', '// Borrowed from MiniMeToken\n', '// ----------------------------------------------------------------------------\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20 Token, with the addition of symbol, name and decimals\n', '// Receives ETH and generates tokens\n', '// ----------------------------------------------------------------------------\n', 'contract ADEToken is ERC20Interface, Owned, SafeMath {\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '    uint public totalSupply;\n', '    uint public sellRate;\n', '    uint public buyRate;\n', '    \n', '    uint private lockRate = 30 days;\n', '    \n', '    struct lockPosition{\n', '        uint time;\n', '        uint count;\n', '        uint releaseRate;\n', '    }\n', '    \n', '    mapping(address => lockPosition) private lposition;\n', '    \n', '    // locked account dictionary that maps addresses to boolean\n', '    mapping (address => bool) private lockedAccounts;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '    \n', '    modifier is_not_locked(address _address) {\n', '        if (lockedAccounts[_address] == true) revert();\n', '        _;\n', '    }\n', '    \n', '    modifier validate_address(address _address) {\n', '        if (_address == address(0)) revert();\n', '        _;\n', '    }\n', '    \n', '    modifier is_locked(address _address) {\n', '        if (lockedAccounts[_address] != true) revert();\n', '        _;\n', '    }\n', '    \n', '    modifier validate_position(address _address,uint count) {\n', '        if(balances[_address] < count * 10**uint(decimals)) revert();\n', '        if(lposition[_address].count > 0 && (balances[_address] - (count * 10**uint(decimals))) < lposition[_address].count && now < lposition[_address].time) revert();\n', '        checkPosition(_address,count);\n', '        _;\n', '    }\n', '    function checkPosition(address _address,uint count) private view {\n', '        if(lposition[_address].releaseRate < 100 && lposition[_address].count > 0){\n', '            uint _rate = safeDiv(100,lposition[_address].releaseRate);\n', '            uint _time = lposition[_address].time;\n', '            uint _tmpRate = lposition[_address].releaseRate;\n', '            uint _tmpRateAll = 0;\n', '            uint _count = 0;\n', '            for(uint _a=1;_a<=_rate;_a++){\n', '                if(now >= _time){\n', '                    _count = _a;\n', '                    _tmpRateAll = safeAdd(_tmpRateAll,_tmpRate);\n', '                    _time = safeAdd(_time,lockRate);\n', '                }\n', '            }\n', '            if(_count < _rate && lposition[_address].count > 0 && (balances[_address] - count * 10**uint(decimals)) < (lposition[_address].count - safeDiv(lposition[_address].count*_tmpRateAll,100)) && now >= lposition[_address].time) revert();   \n', '        }\n', '    }\n', '    \n', '    event _lockAccount(address _add);\n', '    event _unlockAccount(address _add);\n', '    \n', '    function () public payable{\n', '        require(owner != msg.sender);\n', '        require(buyRate > 0);\n', '        \n', '        require(msg.value >= 0.1 ether && msg.value <= 1000 ether);\n', '        uint tokens;\n', '        \n', '        tokens = msg.value / (1 ether * 1 wei / buyRate);\n', '        \n', '        \n', '        require(balances[owner] >= tokens * 10**uint(decimals));\n', '        balances[msg.sender] = safeAdd(balances[msg.sender], tokens * 10**uint(decimals));\n', '        balances[owner] = safeSub(balances[owner], tokens * 10**uint(decimals));\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Constructor\n', '    // ------------------------------------------------------------------------\n', '    function ADEToken(uint _sellRate,uint _buyRate) public payable {\n', '        symbol = "ADE";\n', '        name = "AdeCoin";\n', '        decimals = 8;\n', '        totalSupply = 2000000000 * 10**uint(decimals);\n', '        balances[owner] = totalSupply;\n', '        Transfer(address(0), owner, totalSupply);\n', '        sellRate = _sellRate;\n', '        buyRate = _buyRate;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Total supply\n', '    // ------------------------------------------------------------------------\n', '    function totalSupply() public constant returns (uint) {\n', '        return totalSupply  - balances[address(0)];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Get the token balance for account `tokenOwner`\n', '    // ------------------------------------------------------------------------\n', '    function balanceOf(address tokenOwner) public constant returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', "    // Transfer the balance from token owner's account to `to` account\n", "    // - Owner's account must have sufficient balance to transfer\n", '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transfer(address to, uint tokens) public is_not_locked(msg.sender) is_not_locked(to) validate_position(msg.sender,tokens / (10**uint(decimals))) returns (bool success) {\n', '        require(to != msg.sender);\n', '        require(tokens > 0);\n', '        require(balances[msg.sender] >= tokens);\n', '        balances[msg.sender] = safeSub(balances[msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account\n", '    //\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '    // recommends that there are no checks for the approval double-spend attack\n', '    // as this should be implemented in user interfaces \n', '    // ------------------------------------------------------------------------\n', '    function approve(address spender, uint tokens) public is_not_locked(msg.sender) is_not_locked(spender) validate_position(msg.sender,tokens / (10**uint(decimals))) returns (bool success) {\n', '        require(spender != msg.sender);\n', '        require(tokens > 0);\n', '        require(balances[msg.sender] >= tokens);\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Transfer `tokens` from the `from` account to the `to` account\n', '    // \n', '    // The calling account must already have sufficient tokens approve(...)-d\n', '    // for spending from the `from` account and\n', '    // - From account must have sufficient balance to transfer\n', '    // - Spender must have sufficient allowance to transfer\n', '    // - 0 value transfers are allowed\n', '    // ------------------------------------------------------------------------\n', '    function transferFrom(address from, address to, uint tokens) public is_not_locked(msg.sender) is_not_locked(from) is_not_locked(to) validate_position(from,tokens / (10**uint(decimals))) returns (bool success) {\n', '        require(transferFromCheck(from,to,tokens));\n', '        return true;\n', '    }\n', '    \n', '    function transferFromCheck(address from,address to,uint tokens) private returns (bool success) {\n', '        require(tokens > 0);\n', '        require(from != msg.sender && msg.sender != to && from != to);\n', '        require(balances[from] >= tokens && allowed[from][msg.sender] >= tokens);\n', '        balances[from] = safeSub(balances[from], tokens);\n', '        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);\n', '        balances[to] = safeAdd(balances[to], tokens);\n', '        Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns the amount of tokens approved by the owner that can be\n', "    // transferred to the spender's account\n", '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Token owner can approve for `spender` to transferFrom(...) `tokens`\n', "    // from the token owner's account. The `spender` contract function\n", '    // `receiveApproval(...)` is then executed\n', '    // ------------------------------------------------------------------------\n', '    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);\n', '        return true;\n', '    }\n', '    \n', '\n', '    // ------------------------------------------------------------------------\n', '    // Sall a token from a contract\n', '    // ------------------------------------------------------------------------\n', '    function sellCoin(address seller, uint amount) public onlyOwner is_not_locked(seller) validate_position(seller,amount){\n', '        require(balances[seller] >= amount * 10**uint(decimals));\n', '        require(sellRate > 0);\n', '        require(seller != msg.sender);\n', '        uint tmpAmount = amount * (1 ether * 1 wei / sellRate);\n', '        \n', '        balances[owner] += amount * 10**uint(decimals);\n', '        balances[seller] -= amount * 10**uint(decimals);\n', '        \n', '        seller.transfer(tmpAmount);\n', '        TransferSell(seller, amount * 10**uint(decimals), tmpAmount);\n', '    }\n', '    \n', '    // set rate\n', '    function setRate(uint _buyRate,uint _sellRate) public onlyOwner {\n', '        require(_buyRate > 0);\n', '        require(_sellRate > 0);\n', '        require(_buyRate < _sellRate);\n', '        buyRate = _buyRate;\n', '        sellRate = _sellRate;\n', '    }\n', '    \n', '    //set lock position\n', '    function setLockPostion(address _add,uint _count,uint _time,uint _releaseRate) public is_not_locked(_add) onlyOwner {\n', '        require(_time > now);\n', '        require(_count > 0);\n', '        require(_releaseRate > 0 && _releaseRate <= 100);\n', '        require(_releaseRate == 2 || _releaseRate == 4 || _releaseRate == 5 || _releaseRate == 10 || _releaseRate == 20 || _releaseRate == 25 || _releaseRate == 50);\n', '        require(balances[_add] >= _count * 10**uint(decimals));\n', '        lposition[_add].time = _time;\n', '        lposition[_add].count = _count * 10**uint(decimals);\n', '        lposition[_add].releaseRate = _releaseRate;\n', '    }\n', '    \n', '    // lockAccount\n', '    function lockStatus(address _owner) public is_not_locked(_owner)  validate_address(_owner) onlyOwner {\n', '        lockedAccounts[_owner] = true;\n', '        _lockAccount(_owner);\n', '    }\n', '\n', '    /// @notice only the admin is allowed to unlock accounts.\n', '    /// @param _owner the address of the account to be unlocked\n', '    function unlockStatus(address _owner) public is_locked(_owner) validate_address(_owner) onlyOwner {\n', '        lockedAccounts[_owner] = false;\n', '        _unlockAccount(_owner);\n', '    }\n', '    \n', '    //get lockedaccount\n', '    function getLockStatus(address _owner) public view returns (bool _lockStatus) {\n', '        return lockedAccounts[_owner];\n', '    }\n', '    \n', '    //get lockPosition info\n', '    function getLockPosition(address _add) public view returns(uint time,uint count,uint rate,uint scount) {\n', '        \n', '        return (lposition[_add].time,lposition[_add].count,lposition[_add].releaseRate,positionScount(_add));\n', '    }\n', '    \n', '    function positionScount(address _add) private view returns (uint count){\n', '        uint _rate = safeDiv(100,lposition[_add].releaseRate);\n', '        uint _time = lposition[_add].time;\n', '        uint _tmpRate = lposition[_add].releaseRate;\n', '        uint _tmpRateAll = 0;\n', '        for(uint _a=1;_a<=_rate;_a++){\n', '            if(now >= _time){\n', '                _tmpRateAll = safeAdd(_tmpRateAll,_tmpRate);\n', '                _time = safeAdd(_time,lockRate);\n', '            }\n', '        }\n', '        \n', '        return (lposition[_add].count - safeDiv(lposition[_add].count*_tmpRateAll,100));\n', '    }\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Owner can transfer out any accidentally sent ERC20 tokens\n', '    // ------------------------------------------------------------------------\n', '    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {\n', '        return ERC20Interface(tokenAddress).transfer(owner, tokens);\n', '    }\n', '}']