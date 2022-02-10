['pragma solidity ^0.4.21;\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) \n', '    {\n', '        if (a == 0) \n', '        {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return a / b;\n', '    }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) \n', '    {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title 项目管理员基类\n', ' * @dev 可持有合同具有所有者地址，并提供基本的授权控制\n', '*      函数，这简化了“用户权限”的实现。\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '\n', '// @dev Ownable构造函数将合约的原始“所有者”设置为发件人帐户。\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '//@dev如果由所有者以外的任何帐户调用，则抛出异常。\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '//@dev允许当前所有者将合同的控制权转移给新的用户。\n', '//@param newOwner将所有权转让给的地址。\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '//@title可用\n', '//@dev基地合同允许实施紧急停止机制。\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '//@dev修饰符仅在合约未暂停时才可调用函数。\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '//@dev修饰符只有在合约被暂停时才可以调用函数。\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '//@dev由所有者调用暂停，触发器停止状态\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '//@dev被所有者调用以取消暂停，恢复到正常状态\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '//@title基本令牌\n', '//@dev StandardToken的基本版本，没有限制。\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    uint256 totalSupply_;\n', '\n', '//@dev token总数\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '\n', '//指定地址的@dev转移令牌\n', '//@param _to要转移到的地址。\n', '//@param _value要转移的金额。\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '//\n', '//@dev获取指定地址的余额。\n', '//@param _owner查询余额的地址。\n', '//@return uint256表示通过地址所拥有的金额。\n', '    function balanceOf(address _owner) public view returns (uint256) \n', '    {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '// @title ERC20 interface\n', '// @dev see https://github.com/ethereum/EIPs/issues/20\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '\n', '//@dev 销毁特定数量的令牌。\n', '//@param _value要销毁的令牌数量。\n', '\n', '    function burn(uint256 _value) public {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _who, uint256 _value) internal {\n', '        require(_value <= balances[_who]);  \n', '    //不需要value <= totalSupply，因为这意味着\n', '    //发件人的余额大于totalSupply，这应该是断言失败\n', '\n', '        balances[_who] = balances[_who].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '    }\n', '}\n', '\n', '//@title Standard ERC20 token\n', '//@dev Implementation of the basic standard token.\n', '//@dev https://github.com/ethereum/EIPs/issues/20\n', '//@dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', '\n', 'contract StandardToken is ERC20, BasicToken,Ownable{\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '\n', '//@dev将令牌从一个地址转移到另一个地址\n', '//@param _to地址您想要转移到的地址\n', '//@param _value uint256要传输的令牌数量\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '//@dev批准传递的地址以代表msg.sender花费指定数量的令牌。\n', '//请注意，使用此方法更改津贴会带来有人可能同时使用旧版本的风险\n', '//以及由不幸交易订购的新补贴。 一种可能的解决方案来减轻这一点\n', '//比赛条件是首先将分配者的津贴减至0，然后设定所需的值：\n', '// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '// @param _spender将花费资金的地址。\n', '// @param _value花费的令牌数量。\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '//@dev函数来检查所有者允许购买的代币数量。\n', '// @param _owner地址拥有资金的地址。\n', '//@param _spender地址将花费资金的地址。\n', '// @return一个uint256，指定仍可用于该支付者的令牌数量。\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '\n', '// @dev增加所有者允许购买的代币数量。\n', '//批准时应允许调用[_spender] == 0.要增加\n', '//允许值最好使用这个函数来避免2次调用（并等待\n', '//第一笔交易是开采的）\n', '//来自MonolithDAO Token.sol\n', '// @param _spender将花费资金的地址。\n', '// @param _addedValue用于增加津贴的令牌数量。\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '\n', '// @dev减少所有者允许购买的代币数量。\n', '//允许时调用批准[_spender] == 0.递减\n', '//允许值最好使用这个函数来避免2次调用（并等待\n', '//第一笔交易是开采的）\n', '//来自MonolithDAO Token.sol\n', '// @param _spender将花费资金的地址。\n', '// @param _subtractedValue用于减少津贴的令牌数量。\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) \n', '        {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '/*  自定义的最终Token代码 */\n', 'contract NDT2Token is BurnableToken, StandardToken,Pausable {\n', '    /*这会在区块链上产生一个公共事件，通知客户端*/\n', '    mapping (address => bool) public frozenAccount;\n', '    event FrozenFunds(address target, bool frozen);\n', '    function NDT2Token() public \n', '    {\n', '        totalSupply_ = 10000000000 ether;//代币总量,单位eth\n', '        balances[msg.sender] = totalSupply_;               //为创建者提供所有初始令牌\n', '        name = "NDT2Token";             //为显示目的设置交易名称\n', '        symbol = "NDT2";                               //为显示目的设置交易符号简称\n', '    }\n', '\n', '//@dev从目标地址和减量津贴中焚烧特定数量的标记\n', '//@param _from地址您想从中发送令牌的地址\n', '//@param _value uint256要被刻录的令牌数量\n', '\n', '    function burnFrom(address _from, uint256 _value) public {\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '        //此功能需要发布具有更新批准的事件。\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        _burn(_from, _value);\n', '    }\n', '    //锁定一个账号,只有管理员才能执行\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[msg.sender]);               //检查发送人是否被冻结\n', '        return super.transfer(_to, _value);\n', '    }\n', '    //发送代币到某个账号并且马上锁定这个账号,只有管理员才能执行\n', '    function transferAndFrozen(address _to, uint256 _value) onlyOwner public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[msg.sender]);               //检查发送人是否被冻结\n', '        bool Result = transfer(_to,_value);\n', '        freezeAccount(_to,true);\n', '        return Result;\n', '    }\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[_from]);                     //检查发送人是否被冻结\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}']
['pragma solidity ^0.4.21;\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) \n', '    {\n', '        if (a == 0) \n', '        {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) \n', '    {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title 项目管理员基类\n', ' * @dev 可持有合同具有所有者地址，并提供基本的授权控制\n', '*      函数，这简化了“用户权限”的实现。\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '\n', '// @dev Ownable构造函数将合约的原始“所有者”设置为发件人帐户。\n', '\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '//@dev如果由所有者以外的任何帐户调用，则抛出异常。\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '//@dev允许当前所有者将合同的控制权转移给新的用户。\n', '//@param newOwner将所有权转让给的地址。\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '//@title可用\n', '//@dev基地合同允许实施紧急停止机制。\n', '\n', 'contract Pausable is Ownable {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '//@dev修饰符仅在合约未暂停时才可调用函数。\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '//@dev修饰符只有在合约被暂停时才可以调用函数。\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '//@dev由所有者调用暂停，触发器停止状态\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '//@dev被所有者调用以取消暂停，恢复到正常状态\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '//@title基本令牌\n', '//@dev StandardToken的基本版本，没有限制。\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals = 18;\n', '    uint256 totalSupply_;\n', '\n', '//@dev token总数\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '\n', '//指定地址的@dev转移令牌\n', '//@param _to要转移到的地址。\n', '//@param _value要转移的金额。\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '//\n', '//@dev获取指定地址的余额。\n', '//@param _owner查询余额的地址。\n', '//@return uint256表示通过地址所拥有的金额。\n', '    function balanceOf(address _owner) public view returns (uint256) \n', '    {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', '// @title ERC20 interface\n', '// @dev see https://github.com/ethereum/EIPs/issues/20\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BurnableToken is BasicToken {\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '\n', '//@dev 销毁特定数量的令牌。\n', '//@param _value要销毁的令牌数量。\n', '\n', '    function burn(uint256 _value) public {\n', '        _burn(msg.sender, _value);\n', '    }\n', '\n', '    function _burn(address _who, uint256 _value) internal {\n', '        require(_value <= balances[_who]);  \n', '    //不需要value <= totalSupply，因为这意味着\n', '    //发件人的余额大于totalSupply，这应该是断言失败\n', '\n', '        balances[_who] = balances[_who].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(_who, _value);\n', '        emit Transfer(_who, address(0), _value);\n', '    }\n', '}\n', '\n', '//@title Standard ERC20 token\n', '//@dev Implementation of the basic standard token.\n', '//@dev https://github.com/ethereum/EIPs/issues/20\n', '//@dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', '\n', 'contract StandardToken is ERC20, BasicToken,Ownable{\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '\n', '//@dev将令牌从一个地址转移到另一个地址\n', '//@param _to地址您想要转移到的地址\n', '//@param _value uint256要传输的令牌数量\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '//@dev批准传递的地址以代表msg.sender花费指定数量的令牌。\n', '//请注意，使用此方法更改津贴会带来有人可能同时使用旧版本的风险\n', '//以及由不幸交易订购的新补贴。 一种可能的解决方案来减轻这一点\n', '//比赛条件是首先将分配者的津贴减至0，然后设定所需的值：\n', '// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '// @param _spender将花费资金的地址。\n', '// @param _value花费的令牌数量。\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '//@dev函数来检查所有者允许购买的代币数量。\n', '// @param _owner地址拥有资金的地址。\n', '//@param _spender地址将花费资金的地址。\n', '// @return一个uint256，指定仍可用于该支付者的令牌数量。\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '\n', '// @dev增加所有者允许购买的代币数量。\n', '//批准时应允许调用[_spender] == 0.要增加\n', '//允许值最好使用这个函数来避免2次调用（并等待\n', '//第一笔交易是开采的）\n', '//来自MonolithDAO Token.sol\n', '// @param _spender将花费资金的地址。\n', '// @param _addedValue用于增加津贴的令牌数量。\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '\n', '// @dev减少所有者允许购买的代币数量。\n', '//允许时调用批准[_spender] == 0.递减\n', '//允许值最好使用这个函数来避免2次调用（并等待\n', '//第一笔交易是开采的）\n', '//来自MonolithDAO Token.sol\n', '// @param _spender将花费资金的地址。\n', '// @param _subtractedValue用于减少津贴的令牌数量。\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) \n', '        {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '}\n', '\n', '/*  自定义的最终Token代码 */\n', 'contract NDT2Token is BurnableToken, StandardToken,Pausable {\n', '    /*这会在区块链上产生一个公共事件，通知客户端*/\n', '    mapping (address => bool) public frozenAccount;\n', '    event FrozenFunds(address target, bool frozen);\n', '    function NDT2Token() public \n', '    {\n', '        totalSupply_ = 10000000000 ether;//代币总量,单位eth\n', '        balances[msg.sender] = totalSupply_;               //为创建者提供所有初始令牌\n', '        name = "NDT2Token";             //为显示目的设置交易名称\n', '        symbol = "NDT2";                               //为显示目的设置交易符号简称\n', '    }\n', '\n', '//@dev从目标地址和减量津贴中焚烧特定数量的标记\n', '//@param _from地址您想从中发送令牌的地址\n', '//@param _value uint256要被刻录的令牌数量\n', '\n', '    function burnFrom(address _from, uint256 _value) public {\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '        //此功能需要发布具有更新批准的事件。\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        _burn(_from, _value);\n', '    }\n', '    //锁定一个账号,只有管理员才能执行\n', '    function freezeAccount(address target, bool freeze) onlyOwner public {\n', '        frozenAccount[target] = freeze;\n', '        emit FrozenFunds(target, freeze);\n', '    }\n', '    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[msg.sender]);               //检查发送人是否被冻结\n', '        return super.transfer(_to, _value);\n', '    }\n', '    //发送代币到某个账号并且马上锁定这个账号,只有管理员才能执行\n', '    function transferAndFrozen(address _to, uint256 _value) onlyOwner public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[msg.sender]);               //检查发送人是否被冻结\n', '        bool Result = transfer(_to,_value);\n', '        freezeAccount(_to,true);\n', '        return Result;\n', '    }\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {\n', '        require(!frozenAccount[_from]);                     //检查发送人是否被冻结\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}']
