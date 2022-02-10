['pragma solidity ^0.4.4;\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract Token is SafeMath {\n', '\n', '    function totalSupply()public constant returns (uint256 supply) {}\n', '\n', '    function balanceOf(address _owner)public constant returns (uint256 balance) {}\n', '    \n', '   \n', '    \n', '    function transfer(address _to, uint256 _value)public returns (bool success) {}\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {}\n', '\n', '    function approve(address _spender, uint256 _value)public returns (bool success) {}\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '}\n', '\n', '\n', '//ERC20 Compliant\n', 'contract StandardToken is Token {\n', '\n', '    \n', '    \n', '    \n', '    \n', '    function transfer(address _to, uint256 _value) public  returns (bool success) {\n', '        if (balances[msg.sender] >= _value && _value > 0)\n', '        {\n', '            if(inflation_complete)\n', '            {\n', '              \n', '                uint256 CalculatedFee = safeMul(safeDiv(transactionfeeAmount,100000000000000),transactionfeeAmount);\n', '                balances[msg.sender] = safeSub(balances[msg.sender],_value);\n', '               _value = safeSub(_value,CalculatedFee);\n', '                totalFeeCollected = safeAdd(totalFeeCollected,CalculatedFee);\n', '                balances[_to] = safeAdd(balances[_to],_value);\n', '                Transfer(msg.sender, _to, _value);\n', '                return true;\n', '            }\n', '            else\n', '            {\n', '                balances[msg.sender] = safeSub(balances[msg.sender],_value);\n', '                balances[_to] = safeAdd(balances[_to],_value);\n', '                Transfer(msg.sender, _to, _value);\n', '                return true;\n', '                \n', '            }\n', '            \n', '        }\n', '        else\n', '        {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] =safeAdd(balances[_to],_value);\n', '            balances[_from] =safeSub(balances[_from],_value);\n', '            allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value); \n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '   \n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '   \n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply=   0;\n', '    uint256 public initialSupply= 2500000*10**12;\n', '    uint256 public rewardsupply= 4500000*10**12;\n', '    bool public inflation_complete;\n', '    uint256 public transactionfeeAmount; // This is the percentage per transaction Hawala.Today shall be collecting \n', '    uint256 public totalFeeCollected;\n', '}\n', '\n', '\n', '\n', 'contract HawalaToken is StandardToken {\n', '\n', '    \n', '    uint256 public  totalstakeamount;\n', '    uint256 public HawalaKickoffTime;\n', '    address _contractOwner;\n', '    uint256 public totalFeeCollected;\n', '  \n', '    string public name;                  \n', '    uint8 public decimals;               \n', '    string public symbol;\n', "    string public version = 'HAT';       \n", '\n', '  mapping (address => IFSBalance) public IFSBalances;\n', '   struct IFSBalance\n', '    {\n', '        \n', '         uint256 TotalRewardsCollected; \n', '        uint256 Amount; \n', '        uint256 IFSLockTime;\n', '        uint256 LastCollectedReward;\n', '    }\n', '    \n', '   \n', '    event IFSActive(address indexed _owner, uint256 _value,uint256 _locktime);\n', '    \n', '    function () public {\n', '        //if ether is sent to this address, send it back.\n', '    \n', '        throw;\n', '    }\n', '\n', '  \n', '\n', '      \n', '\n', '      function CalculateReward(uint256 stakingamount,uint256 initialLockTime,uint256 _currenttime) public returns (uint256 _amount) {\n', '         \n', '        \n', '         uint _timesinceStaking =(uint(_currenttime)-uint(initialLockTime))/ 1 days;\n', '         _timesinceStaking = safeDiv(_timesinceStaking,3);//exploiting non-floating point division\n', '         _timesinceStaking = safeMul(_timesinceStaking,3);//get to number of days reward shall be distributed\n', '        \n', '      \n', '        \n', '         if(safeSub(_currenttime,HawalaKickoffTime) <= 1 years)\n', '         {\n', '             //_amount = 1;//safeMul(safeDiv(stakingamount,100),15));\n', '              \n', '             _amount = safeMul(safeDiv(stakingamount,1000000000000),410958904) ;//15% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));\n', '             _amount = safeMul(_timesinceStaking,_amount);\n', '          \n', '         }\n', '        else if(safeSub(_currenttime,HawalaKickoffTime) <= 2 years)\n', '         {\n', '             _amount = safeMul(safeDiv(stakingamount,1000000000000),410958904) ;//15% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));\n', '             _amount = safeMul(_timesinceStaking,_amount);\n', '             \n', '         }\n', '        else  if(safeSub(_currenttime,HawalaKickoffTime) <= 3 years)\n', '         {\n', '             _amount = safeMul(safeDiv(stakingamount,1000000000000),328767123) ;//12% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));\n', '             _amount = safeMul(_timesinceStaking,_amount);\n', '             \n', '         }\n', '        else  if(safeSub(_currenttime,HawalaKickoffTime) <= 4 years)\n', '         {\n', '             _amount = safeMul(safeDiv(stakingamount,1000000000000),328767123) ;//12% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));\n', '             _amount = safeMul(_timesinceStaking,_amount);\n', '             \n', '         }\n', '       else   if(safeSub(_currenttime,HawalaKickoffTime) <= 5 years)\n', '         {\n', '             _amount = safeMul(safeDiv(stakingamount,1000000000000),328767123) ;//12% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));\n', '             _amount = safeMul(_timesinceStaking,_amount);\n', '             \n', '         }\n', '       else   if(safeSub(_currenttime,HawalaKickoffTime) <= 6 years)\n', '         {\n', '             _amount = safeMul(safeDiv(stakingamount,1000000000000),273972602) ;//10% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));\n', '             _amount = safeMul(_timesinceStaking,_amount);\n', '             \n', '         }\n', '      else    if(safeSub(_currenttime,HawalaKickoffTime) <= 7 years)\n', '         {\n', '             _amount = safeMul(safeDiv(stakingamount,1000000000000),273972602) ;//10%  safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));\n', '             _amount = safeMul(_timesinceStaking,_amount);\n', '             \n', '         }\n', '       else   if(safeSub(_currenttime,HawalaKickoffTime) <= 8 years)\n', '         {\n', '             _amount = safeMul(safeDiv(stakingamount,1000000000000),219178082) ;//8% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));\n', '             _amount = safeMul(_timesinceStaking,_amount);\n', '             \n', '         }\n', '      else    if(safeSub(_currenttime,HawalaKickoffTime) <= 9 years)\n', '         {\n', '             _amount = safeMul(safeDiv(stakingamount,1000000000000),205479452) ;//7.50% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));\n', '             _amount = safeMul(_timesinceStaking,_amount);\n', '             \n', '         }\n', '       else   if(safeSub(_currenttime,HawalaKickoffTime) <= 10 years)\n', '         {\n', '             _amount = safeMul(safeDiv(stakingamount,1000000000000),198630136) ;//7.25% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));\n', '             _amount = safeMul(_timesinceStaking,_amount);\n', '             \n', '         }\n', '        else   if(safeSub(_currenttime,HawalaKickoffTime) > 10 years)\n', '         {\n', '             _amount = safeMul(safeDiv(stakingamount,1000000000000),198630136) ;//7.25% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));\n', '             _amount = safeMul(_timesinceStaking,_amount);\n', '             \n', '         }\n', '         return _amount;\n', '         //extract ony the quotient from _timesinceStaking\n', '        \n', '     }\n', '     \n', '     function changeTransactionFee(uint256 amount) public returns (bool success)\n', '     {\n', '          if (msg.sender == _contractOwner) {\n', '              \n', '              transactionfeeAmount = amount;\n', '            return true;\n', '          }\n', '       else{\n', '             return false;\n', '         }\n', '     }\n', '     \n', '     function canExecute(uint initialLockTime,uint256 _currenttime) public returns (bool success)\n', '     {\n', '          if (_currenttime >= initialLockTime + 3 days) {\n', '              \n', '            return true;\n', '          }\n', '       else{\n', '             return false;\n', '         }\n', '     }\n', '     \n', '     \n', '      function disperseRewards(address toaddress ,uint256 amount) public returns (bool success){\n', '      \n', '          if(msg.sender==_contractOwner)\n', '          {\n', '             if(inflation_complete)\n', '              {\n', '                  if(totalFeeCollected>0 && totalFeeCollected>amount)\n', '                  {\n', '                    totalFeeCollected = safeSub(totalFeeCollected,amount);\n', '                     balances[toaddress] = safeAdd(balances[toaddress],amount);\n', '                     Transfer(msg.sender, toaddress, amount);\n', '                     return true;\n', '                  }\n', '              \n', '              }\n', '              else\n', '              {\n', '                  return false;\n', '                  \n', '              }\n', '          }\n', '          return false;\n', '          \n', '      }\n', '       function claimIFSReward(address _sender) public returns (bool success){\n', '     \n', '       \n', '        if(msg.sender!=_sender)//Make sure only authorize owner of account could trigger IFS and he/she must have enough balance to trigger IFS\n', '        {\n', '            return false;\n', '        }\n', '        else\n', '        {\n', '            if(IFSBalances[_sender].Amount<=0)\n', '            {\n', '                return false;\n', '                \n', '            }\n', '            else{\n', '                // is IFS balance age minimum 3 day?\n', '                uint256 _currenttime = now;\n', '                if(canExecute(IFSBalances[_sender].IFSLockTime,_currenttime))\n', '                {\n', "                    //Get Total number of days in multiple of 3's.. Suppose if the staking lock was done 10 days ago\n", '                    //but the reward shall be allocated and calculated for 9 Days.\n', '                    uint256 calculatedreward = CalculateReward(IFSBalances[_sender].Amount,IFSBalances[_sender].IFSLockTime,_currenttime);\n', '                    \n', '                   if(!inflation_complete)\n', '                   {\n', '                    if(rewardsupply>=calculatedreward)\n', '                    {\n', '                   \n', '                   \n', '                         rewardsupply = safeSub(rewardsupply,calculatedreward);\n', '                         balances[_sender] =safeAdd(balances[_sender], calculatedreward);\n', '                         IFSBalances[_sender].IFSLockTime = _currenttime;//reset the clock\n', '                         IFSBalances[_sender].TotalRewardsCollected = safeAdd( IFSBalances[_sender].TotalRewardsCollected,calculatedreward);\n', '                          IFSBalances[_sender].LastCollectedReward = rewardsupply;//Set this to see last collected reward\n', '                    }\n', '                    else{\n', '                        \n', '                        if(rewardsupply>0)//whatever remaining in the supply hand it out to last staking account\n', '                        {\n', '                              \n', '                           balances[_sender] =safeAdd(balances[_sender], rewardsupply);\n', '                           rewardsupply = 0;\n', '                            \n', '                        }\n', '                        inflation_complete = true;\n', '                        \n', '                    }\n', '                    \n', '                   }\n', '                    \n', '                }\n', '                else{\n', '                    \n', '                    // Not time yet to process staking reward \n', '                    return false;\n', '                }\n', '                \n', '                \n', '                \n', '            }\n', '            return true;\n', '        }\n', '        \n', '    }\n', '   \n', '    function setIFS(address _sender,uint256 _amount) public returns (bool success){\n', '        if(msg.sender!=_sender || balances[_sender]<_amount || rewardsupply==0)//Make sure only authorize owner of account could trigger IFS and he/she must have enough balance to trigger IFS\n', '        {\n', '            return false;\n', '        }\n', '        balances[_sender] = safeSub(balances[_sender],_amount);\n', '        IFSBalances[_sender].Amount = safeAdd(IFSBalances[_sender].Amount,_amount);\n', '        IFSBalances[_sender].IFSLockTime = now;\n', '        IFSActive(_sender,_amount,IFSBalances[_sender].IFSLockTime);\n', '        totalstakeamount =  safeAdd(totalstakeamount,_amount);\n', '        return true;\n', '        \n', '    }\n', '    function reClaimIFS(address _sender)public returns (bool success){\n', '        if(msg.sender!=_sender || IFSBalances[_sender].Amount<=0 )//Make sure only authorize owner of account and > 0 staking could trigger reClaimIFS  \n', '        {\n', '            return false;\n', '        }\n', '        \n', '            balances[_sender] = safeAdd(balances[_sender],IFSBalances[_sender].Amount);\n', '            totalstakeamount =  safeSub(totalstakeamount,IFSBalances[_sender].Amount);\n', '            IFSBalances[_sender].Amount = 0;\n', '            IFSBalances[_sender].IFSLockTime = 0;// \n', '            IFSActive(_sender,0,IFSBalances[_sender].IFSLockTime);//Broadcast event ... Our mobile hooks should be listening to release time\n', '            \n', '            return true; \n', '        \n', '        \n', '    }\n', '    \n', '    \n', '    function HawalaToken(\n', '        )public {\n', '        //Add initial supply to total supply to make  7M. remaining 4.5M locked in for reward distribution        \n', '        totalSupply=safeAdd(initialSupply,rewardsupply);\n', '        balances[msg.sender] = initialSupply;               \n', '        name = "HawalaToken";                              \n', '        decimals = 12;                            \n', '        symbol = "HAT";  \n', '        inflation_complete = false;\n', '        HawalaKickoffTime=now;\n', '        totalstakeamount=0;\n', '        totalFeeCollected=0;\n', '        transactionfeeAmount=100000000000;// Initialized with 0.10 Percent per transaction after 10 years\n', '        _contractOwner = msg.sender;\n', '    }\n', '\n', '   \n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', '        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }\n', '        return true;\n', '    }\n', '}']