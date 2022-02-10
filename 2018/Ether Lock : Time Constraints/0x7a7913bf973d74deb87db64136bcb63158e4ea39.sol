['// compiler: 0.4.20+commit.3155dd80.Emscripten.clang\n', 'pragma solidity ^0.4.20;\n', '\n', 'contract owned {\n', '  address public owner;\n', '\n', '  function owned() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  function changeOwner( address newowner ) public onlyOwner {\n', '    owner = newowner;\n', '  }\n', '\n', '  modifier onlyOwner {\n', '    if (msg.sender != owner) { revert(); }\n', '    _;\n', '  }\n', '}\n', '\n', 'contract Community is owned {\n', '\n', '  event Receipt( address indexed sender, uint value );\n', '\n', '  string  public name_; // "IT", "KO", ...\n', '  address public manager_;\n', '  uint    public bonus_;\n', '  uint    public start_;\n', '  uint    public end_;\n', '\n', '  function Community() public {}\n', '\n', '  function setName( string _name ) public onlyOwner {\n', '    name_ = _name;\n', '  }\n', '\n', '  function setManager( address _mgr ) public onlyOwner {\n', '    manager_ = _mgr;\n', '  }\n', '\n', '  function setBonus( uint _bonus ) public onlyOwner {\n', '    bonus_ = _bonus;\n', '  }\n', '\n', '  function setTimes( uint _start, uint _end ) public onlyOwner {\n', '    require( _end > _start );\n', '\n', '    start_ = _start;\n', '    end_ = _end;\n', '  }\n', '\n', '  // set gas limit to something greater than 24073\n', '  function() public payable {\n', '    require( now >= start_ && now <= end_ );\n', '\n', '    owner.transfer( msg.value );\n', '\n', '    Receipt( msg.sender, msg.value );\n', '  }\n', '}']