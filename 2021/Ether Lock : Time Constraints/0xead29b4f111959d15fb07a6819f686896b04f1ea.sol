['/**\n', ' *Submitted for verification at Etherscan.io on 2021-01-31\n', '*/\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    return a / b;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '//manager contract\n', '//manager superAdmin\n', '//manager admin\n', '//manager superAdmin Auth\n', 'contract managerContract{\n', '    /**\n', '      * Token holder :\n', '      *     a.Holding tokens\n', '      *     b.No permission to transfer tokens privately\n', '      *     c.Cannot receive tokens, similar to dead accounts\n', '      *     d.Can delegate second-level administrators, but only one can be delegated\n', '      *     e.Have the permission to unlock and transfer tokens, but it depends on the unlocking rules (9800 DNSS unlocked every day)\n', '      *     f.Has the unlock time setting permission, but can only set one time  the unlock time node once\n', '      */\n', '    address superAdmin;\n', '\n', '    // Secondary ：The only management is to manage illegal users to obtain DNSS by abnormal means\n', '    mapping(address => address) internal admin;\n', '\n', '    //pool address\n', '    address pool;\n', '\n', '    //Depends on super administrator authority\n', '    modifier onlySuper {\n', "        require(msg.sender == superAdmin,'Depends on super administrator');\n", '        _;\n', '    }\n', '}\n', '\n', '//unLock contract\n', '//manager unLock startTime\n', '//manager circulation ( mining pool out total  )\n', '//manager calculate the number of unlocked DNSS fuction\n', 'contract unLockContract {\n', '\n', '    //use safeMath for Prevent overflow\n', '    using SafeMath for uint256;\n', '\n', '    //start unLock time\n', '    uint256 public startTime;\n', '    //use totalOut for Prevent Locked DNSS overflow\n', '    uint256 public totalToPool = 0;\n', "    //Can't burn DNSS Is 10% of the totalSupply\n", '    uint256 public sayNo = 980 * 1000 * 1000000000000000000 ;\n', '\n', '    //get totalUnLockAmount\n', '    function totalUnLockAmount() internal view returns (uint256 _unLockTotalAmount) {\n', '        //unLock start Time not is zero\n', '        if(startTime==0){ return 0;}\n', '        //Has not started to unlock\n', '        if(now <= startTime){ return 0; }\n', '        //unlock total count\n', '        uint256 dayDiff = (now.sub(startTime)) .div (1 days);\n', '        //Total unlocked quantity in calculation period\n', '        uint256 totalUnLock = dayDiff.mul(9800).mul(1000000000000000000);\n', '        //check totalSupply overflow\n', '        if(totalUnLock >= (980 * 10000 * 1000000000000000000)){\n', '            return 980 * 10000 * 1000000000000000000;\n', '        }\n', '        //return Unlocked DNSS total\n', '        return totalUnLock;\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', '* DNSS follows the erc-20 protocol\n', '* In order to maintain the maximum rights and interests of DNSS users and achieve\n', '* a completely decentralized consensus mechanism, DNSS will restrict anyone from\n', '* stealing any 9.8 million DNSS from the issuing account, including holders.\n', '* The only way is through the DNSS community committee. The cycle is unlocked for circulation,\n', '* and the DNSS community committee will rigidly restrict the circulation of tokens through this smart contract.\n', '* In order to achieve future deflation of DNSS, the contract will destroy DNSS through the destruction mechanism.\n', '*/\n', 'contract dnss is managerContract,unLockContract{\n', '\n', '    string public constant name     = "Distributed Number Shared Settlement";\n', '    string public constant symbol   = "DNSS";\n', '    uint8  public constant decimals = 18;\n', '    uint256 public totalSupply = 980 * 10000 * 1000000000000000000 ;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    \n', '    //use totalBurn for Record the number of burns\n', '    mapping (address => uint256) public balanceBurn;\n', '   \n', '\n', '    //event\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    //init\n', '    constructor() public {\n', '        superAdmin = msg.sender ;\n', '        balanceOf[superAdmin] = totalSupply;\n', '    }\n', '    \n', '    //Get unlocked DNSS total\n', '    function totalUnLock() public view returns(uint256 _unlock){\n', '       return totalUnLockAmount();\n', '    }\n', '\n', '\n', '    //Only the super administrator can set the start unlock time\n', '    function setTime(uint256 _startTime) public onlySuper returns (bool success) {\n', "        require(startTime==0,'already started');\n", "        require(_startTime > now,'The start time cannot be less than or equal to the current time');\n", '        startTime = _startTime;\n', "        require(startTime == _startTime,'The start time was not set successfully');\n", '        return true;\n', '    }\n', '\n', '    //Approve admin\n', '    function superApproveAdmin(address _adminAddress) public onlySuper  returns (bool success) {\n', '        //check admin\n', "        require(_adminAddress != 0x0,'is bad');\n", '        admin[_adminAddress] = _adminAddress;\n', '        //check admin\n', '        if(admin[_adminAddress] == 0x0){\n', '             return false;\n', '        }\n', '        return true;\n', '    }\n', '\n', '\n', '   //Approve pool address\n', '    function superApprovePool(address _poolAddress) public onlySuper  returns (bool success) {\n', "        require(_poolAddress != 0x0,'is bad');\n", '        pool = _poolAddress; //Approve pool\n', "        require(pool == _poolAddress,'is failed');\n", '        return true;\n', '    }\n', '\n', '\n', '    //burn target address token amout\n', '    //burn total DNSS not more than 90% of the totalSupply\n', '    function superBurnFrom(address _burnTargetAddess, uint256 _value) public onlySuper returns (bool success) {\n', "        require(balanceOf[_burnTargetAddess] >= _value,'Not enough balance');\n", "        require(totalSupply > _value,' SHIT ! YOURE A FUCKING BAD GUY ! Little bitches ');\n", '        //check burn not more than 90% of the totalSupply\n', "        require(totalSupply.sub(_value) >= sayNo,' SHIT ! YOURE A FUCKING BAD GUY ! Little bitches ');\n", '        //burn target address\n', '        balanceOf[_burnTargetAddess] = balanceOf[_burnTargetAddess].sub(_value);\n', '        //totalSupply reduction\n', '        totalSupply=totalSupply.sub(_value);\n', '        emit Burn(_burnTargetAddess, _value);\n', '        //Cumulative DNSS of burns\n', '        balanceBurn[superAdmin] = balanceBurn[superAdmin].add(_value);\n', '        //burn successfully\n', '        return true;\n', '    }\n', '\n', '\n', '    //Unlock to the mining pool account\n', '    function superUnLock( address _poolAddress , uint256 _amount ) public onlySuper {\n', "        require(pool==_poolAddress,'Mine pool address error');\n", "        require( totalToPool.add(_amount)  <= totalSupply ,'totalSupply balance low');\n", '        //get total UnLock Amount\n', '        uint256 _unLockTotalAmount = totalUnLockAmount();\n', "        require( totalToPool.add(_amount)  <= _unLockTotalAmount ,'Not enough dnss has been unlocked');\n", '        //UnLock totalSupply to pool\n', '        balanceOf[_poolAddress]=balanceOf[_poolAddress].add(_amount);\n', '        //UnLock totalSupply to pool\n', '        balanceOf[superAdmin]=balanceOf[superAdmin].sub(_amount);\n', '        //Cumulative DNSS of UnLock\n', '        totalToPool=totalToPool.add(_amount);\n', '    }\n', '\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', "       require(_from != superAdmin,'Administrator has no rights transfer');\n", "       require(_to != superAdmin,'Administrator has no rights transfer');\n", '       require(_to != 0x0);\n', '       require(balanceOf[_from] >= _value);\n', '       require(balanceOf[_to] + _value > balanceOf[_to]);\n', '       uint256 previousBalances = balanceOf[_from] + balanceOf[_to];\n', '       balanceOf[_from] -= _value;\n', '       balanceOf[_to] += _value;\n', '       emit Transfer(_from, _to, _value);\n', '       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '    }\n', '\n', '\n', '     //superAdmin not transfer\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '         _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '     //superAdmin not transfer ;\n', '     //allowance transfer\n', '     //everyone can transfer\n', '     //admin can transfer Illegally acquired assets\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        //admin Manage illegal assets\n', '        if(admin[msg.sender] != 0x0){\n', '          _transfer(_from, _to, _value);\n', '        } \n', '        return true;\n', '    }\n', '\n', '}']