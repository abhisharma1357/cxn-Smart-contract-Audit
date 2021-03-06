
pragma solidity 0.5.16;


library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

}




contract XYZ {
    
    using SafeMath for uint256;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    bool private _initialized;

    uint256 private _burnRate; // 7%
    uint256 private _forStakers; // 4%

    uint256 private _burnRateStaker;
    uint256 private _unstakeForStaker;

    uint256 private _Burnt_Limit;
    uint256 private _Min_Stake;

    uint256 private _Scale;
    

    struct Party {
        bool elite;
        uint256 balance;
        uint256 staked;
        uint256 payoutstake;
        mapping(address => uint256) allowance;
    }

    struct Board {
        uint256 totalSupply;
        uint256 totalStaked;
        uint256 totalBurnt;
        uint256 retPerToken;
        mapping(address => Party) parties;
        address owner;
    }

    Board private _board;


    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed owner, address indexed spender, uint256 tokens);
    event Eliters(address indexed Party, bool status);
    event Stake(address indexed owner, uint256 tokens);
    event UnStake(address indexed owner, uint256 tokens);
    event StakeGain(address indexed owner, uint256 tokens);
    event Burn(uint256 tokens);


    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor () public {
        
        require(!_initialized);

       _totalSupply = 3e26;
       _name = "XYZ Network";
       _symbol = "XYZ";
       _decimals = 18;
       _burnRate = 7;
       _forStakers = 4;
       _burnRateStaker = 5;
       _unstakeForStaker= 3;
       _Burnt_Limit=1e26;
       _Scale = 2**64;
       _Min_Stake= 1000;
       
        _board.owner = msg.sender;
        _board.totalSupply = _totalSupply;
        _board.parties[msg.sender].balance = _totalSupply;
        _board.retPerToken = 0;
        emit Transfer(address(0x0), msg.sender, _totalSupply);
        eliters(msg.sender, true);

        _initialized = true;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() external view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _board.totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _board.parties[account].balance;
    }

    function stakeOf(address account) public view returns (uint256) {
        return _board.parties[account].staked;
    }

    function totalStake() public view returns (uint256) {
        return _board.totalStaked;
    }

    function changeAdmin(address _to) external {
        require(msg.sender == _board.owner);
        
        
        transfer(_to,_board.parties[msg.sender].balance);
        eliters(_to,true);
        
        _board.owner = msg.sender;
        
    }

    function transfer(address recipient, uint256 amount) public  returns (bool) {
        _transfer(msg.sender, recipient, amount);
        
        return true;
    }

    function allowance(address owner, address spender) external view  returns (uint256) {
        return _board.parties[owner].allowance[spender];
    }

    function approve(address spender, uint256 amount) external  returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external  returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _board.parties[sender].allowance[msg.sender].sub(amount, "XYZ: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) external  returns (bool) {
        _approve(msg.sender, spender, _board.parties[msg.sender].allowance[spender].add(addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint256 subtractedValue) external  returns (bool) {
        _approve(msg.sender, spender, _board.parties[msg.sender].allowance[spender].sub(subtractedValue, "XYZ: decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal  {
        require(sender != address(0), "XYZ: transfer from the zero address");
        require(recipient != address(0), "XYZ: transfer to the zero address");
        require(balanceOf(sender) >= amount);

        _board.parties[sender].balance = _board.parties[sender].balance.sub(amount, "XYZ: transfer amount exceeds balance");

        uint256 toBurn = amount.mul(_burnRate).div(100);

        if(_board.totalSupply < _Burnt_Limit || _board.parties[sender].elite){
            toBurn = 0;
        }
        uint256 _transferred = amount.sub(toBurn);

        _board.parties[recipient].balance = _board.parties[recipient].balance.add(_transferred);
        
        emit Transfer(sender,recipient,_transferred);

        if(toBurn > 0){
            if(_board.totalStaked > 0){
                uint256 toDistribute = amount.mul(_forStakers).div(100);

               _board.retPerToken = _board.retPerToken.add(toDistribute.mul(_Scale).div(_board.totalStaked));

              toBurn = toBurn.sub(toDistribute);
            }

            _board.totalSupply = _board.totalSupply.sub(toBurn);
            emit Transfer(sender, address(0x0), toBurn);
            emit Burn(toBurn);
        }

        
    }

    function _approve(address owner, address spender, uint256 amount) internal  {
        require(owner != address(0), "XYZ: approve from the zero address");
        require(spender != address(0), "XYZ: approve to the zero address");

        _board.parties[owner].allowance[spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function eliters(address party, bool _status) public {
        require(msg.sender == _board.owner);
        _board.parties[party].elite = _status;
        emit Eliters(party, _status);
    }

    function stake(uint256 amount) external  {
        require(balanceOf(msg.sender) >= amount);
        require(amount >= _Min_Stake);
        
        redeemGain();

        _board.totalStaked = _board.totalStaked.add(amount);
        _board.parties[msg.sender].balance = _board.parties[msg.sender].balance.sub(amount);
        _board.parties[msg.sender].staked = _board.parties[msg.sender].staked.add(amount);
        _board.parties[msg.sender].payoutstake = _board.retPerToken;
        

        emit Stake(msg.sender, amount);
    }

    function unStake(uint256 amount) external  {
        require(_board.parties[msg.sender].staked >= amount);

        uint256 toBurn = amount.mul(_burnRateStaker).div(100);

        uint256 toStakers = amount.mul(_unstakeForStaker).div(100);
        
        uint256 stakeGainOfAmount = _stakeReturnOfAmount(msg.sender,amount);
        
        _board.parties[msg.sender].balance = _board.parties[msg.sender].balance.add(stakeGainOfAmount);
        
        
        _board.totalStaked = _board.totalStaked.sub(amount);

        _board.retPerToken = _board.retPerToken.add(toStakers.mul(_Scale).div(_board.totalStaked));
        
        uint256 toReturn = amount.sub(toBurn);
        
        _board.parties[msg.sender].balance = _board.parties[msg.sender].balance.add(toReturn);
        _board.parties[msg.sender].staked = _board.parties[msg.sender].staked.sub(amount);
        
        emit UnStake(msg.sender, amount);
    }

    function redeemGain() public  returns(uint256){
        uint256 ret = stakeReturnOf(msg.sender);
        if(ret == 0){
            return 0;
        }
        
        _board.parties[msg.sender].payoutstake = _board.retPerToken;
        _board.parties[msg.sender].balance = _board.parties[msg.sender].balance.add(ret);
        emit Transfer(address(this), msg.sender, ret);
        emit StakeGain(msg.sender, ret);
        return ret;
    }

    function stakeReturnOf(address sender) public view returns (uint256) {
        uint256 profitReturnRate = _board.retPerToken.sub(_board.parties[sender].payoutstake);
        return uint256(profitReturnRate.mul(_board.parties[sender].staked).div(_Scale));
        
    }
    
    function _stakeReturnOfAmount(address sender, uint256 amount) internal view returns (uint256) {
        uint256 profitReturnRate = _board.retPerToken.sub(_board.parties[sender].payoutstake);
        return uint256(profitReturnRate.mul(amount).div(_Scale));
    }
    

    function partyDetails(address sender) external view returns (uint256 totalTokenSupply,uint256 totalStakes,uint256 balance,uint256 staked,uint256 stakeReturns){
       return (totalSupply(),totalStake(), balanceOf(sender),stakeOf(sender),stakeReturnOf(sender));
    }

    function setMinStake(uint256 amount) external  returns(uint256) {
         require(msg.sender == _board.owner);
         require(amount > 0);
         _Min_Stake = amount;
         return _Min_Stake;
    }

    function minStake() public view returns(uint256) {
        return _Min_Stake;
    }

}

