const CXN = artifacts.require('CXN.sol');

const { increaseTimeTo, duration } = require('openzeppelin-solidity/test/helpers/increaseTime');
const { latestTime } = require('openzeppelin-solidity/test/helpers/latestTime');

var Web3 = require("web3");
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

var Web3Utils = require('web3-utils');

contract('CXN Contract', async (accounts) => {


    it('Should correctly initialize constructor of CXN token Contract', async () => {

        this.tokenhold = await CXN.new({ gas: 600000000 });

    });

    it('Should check a name of a token', async () => {

        let name = await this.tokenhold.name.call();
        assert.equal(name, "CXN Network");

    });

    it('Should check a symbol of a token', async () => {

        let symbol = await this.tokenhold.symbol.call();
        assert.equal(symbol, "CXN");

    });

    it('Should check a decimal of a token', async () => {

        let decimals = await this.tokenhold.decimals.call();
        assert.equal(decimals, 18);

    });

    it('Should check a balance of a token contract', async () => {

        let owner = await this.tokenhold.balanceOf.call(this.tokenhold.address);
        assert.equal(owner.toNumber()/10**18,0);

    });

    it('Should check a balance of a owner contract', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[0]);
        assert.equal(owner.toString(),'300000000000000000000000000');

    });

    it('Should check a total supply of a contract', async () => {

        let owner = await this.tokenhold.totalSupply();
        assert.equal(owner.toString(),'300000000000000000000000000');

    });

    it('Should check a Min stake contract', async () => {

        let owner = await this.tokenhold.minStake.call();
        assert.equal(owner.toString(),'1000');

    });

    it('Should check a total stake contract', async () => {

        let owner = await this.tokenhold.totalStake.call();
        assert.equal(owner.toString(),'0');

    });

    it('Should check a party stake of deployer of contract', async () => {

        let owner = await this.tokenhold.partyDetails.call(accounts[0]);
        assert.equal(owner[0].toString(),'300000000000000000000000000');

    });


    it('Should check a party stake of deployer of contract 1st', async () => {

        let owner = await this.tokenhold.partyDetails.call(accounts[0]);
        assert.equal(owner[1].toString(),'0');

    });

    it('Should check a party stake of deployer of contract 2nd', async () => {

        let owner = await this.tokenhold.partyDetails.call(accounts[0]);
        assert.equal(owner[2].toString(),'300000000000000000000000000');

    });

    it('Should check a party stake of deployer of contract 3rd', async () => {

        let owner = await this.tokenhold.partyDetails.call(accounts[0]);
        assert.equal(owner[3].toString(),'0');

    });

    it('Should check a party stake of deployer of contract 4th', async () => {

        let owner = await this.tokenhold.partyDetails.call(accounts[0]);
        assert.equal(owner[4].toString(),'0');

    });

    it('Should check a party stake of deployer of contract', async () => {

        let owner = await this.tokenhold.stakeOf(accounts[0]);
        assert.equal(owner.toString(),'0');

    });


    it('Should check a party stake return of deployer of contract', async () => {

        let owner = await this.tokenhold.stakeReturnOf(accounts[0]);
        assert.equal(owner.toString(),'0');

    });


    it("should check approval by accounts 4 to accounts 1 to spend tokens on the behalf of accounts 4", async () => {

        let allowance = await this.tokenhold.allowance.call(accounts[4], accounts[1]);
        assert.equal(allowance, 0, "allowance is wrong when approve");

    });

    it("should Approve accounts[1] to spend specific tokens of accounts[4]", async () => {

        this.tokenhold.approve(accounts[1], web3.utils.toHex(50 * 10 ** 9), { from: accounts[4] });

    });

    it("should check approval by accounts 4 to accounts 1 to spend tokens on the behalf of accounts 4", async () => {

        let allowance = await this.tokenhold.allowance.call(accounts[4], accounts[1]);
        assert.equal(allowance, 50000000000, "allowance is wrong when approve");

    });

    it("should increase Approve accounts[4] to spend specific tokens of accounts[1]", async () => {

        this.tokenhold.increaseAllowance(accounts[1], web3.utils.toHex(50 * 10 ** 9), { from: accounts[4] });

    });

    it("should check approval by accounts 4 to accounts 1 to spend tokens on the behalf of accounts 4", async () => {

        let allowance = await this.tokenhold.allowance.call(accounts[4], accounts[1]);
        assert.equal(allowance, 100000000000, "allowance is wrong when approve");

    });    

    it("should decrease Approve accounts[4] to spend specific tokens of accounts[1]", async () => {

        this.tokenhold.decreaseAllowance(accounts[1], web3.utils.toHex(50 * 10 ** 9), { from: accounts[4] });

    });

    it("should check approval by accounts 4 to accounts 1 to spend tokens on the behalf of accounts 4", async () => {

        let allowance = await this.tokenhold.allowance.call(accounts[4], accounts[1]);
        assert.equal(allowance, 50000000000, "allowance is wrong when approve");

    });

    it('Should check a balance of a beneficiary accounts[1] before sending tokens', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[1]);
        assert.equal(owner.toNumber(),0);

    });

    it('Should check a balance of a owner contract', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[0]);
        assert.equal(owner.toString(),'300000000000000000000000000');

    });

    it('Should be able to transfer token when locking period', async () => {

        await this.tokenhold.transfer(accounts[1],web3.utils.toHex(100 * 10 ** 18), {from : accounts[0]});

    });

    it('Should check a balance of a beneficiary accounts[1] before sending tokens', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[1]);
        assert.equal(owner.toString(),'100000000000000000000');

    });

    it('Should check a balance of a owner contract', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[0]);
        assert.equal(owner.toString(),'299999900000000000000000000');

    });

    it('Should be able to transfer token ', async () => {

        await this.tokenhold.transfer(accounts[2],web3.utils.toHex(500 * 10 ** 18), {from : accounts[0]});

    });

    it('Should check a balance of a beneficiary accounts[1] before sending tokens', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[2]);
        assert.equal(owner.toString(),'500000000000000000000');

    });

    it('Should check a balance of a owner contract', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[0]);
        assert.equal(owner.toString(),'299999400000000000000000000');

    });

    it('Should be able to transfer token ', async () => {

        await this.tokenhold.transfer(accounts[3],web3.utils.toHex(400 * 10 ** 18), {from : accounts[0]});

    });

    it('Should check a balance of a beneficiary accounts[1] before sending tokens', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[3]);
        assert.equal(owner.toString(),'400000000000000000000');

    });

    it('Should check a balance of a owner contract', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[0]);
        assert.equal(owner.toString(),'299999000000000000000000000');

    });

    it('Should be able to transfer token ', async () => {

        await this.tokenhold.transfer(accounts[4],web3.utils.toHex(900 * 10 ** 18), {from : accounts[0]});

    });

    it('Should check a balance of a beneficiary accounts[1] before sending tokens', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[4]);
        assert.equal(owner.toString(),'900000000000000000000');

    });

    it('Should check a balance of a owner contract', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[0]);
        assert.equal(owner.toString(),'299998100000000000000000000');

    });

    it('Should be able to stake token by accounts[4] ', async () => {

        await this.tokenhold.stake(web3.utils.toHex(900 * 10 ** 18), {from : accounts[4]});

    });


    it('Should be able to stake token by accounts[3] ', async () => {

        await this.tokenhold.stake(web3.utils.toHex(400 * 10 ** 18), {from : accounts[3]});

    });

    it('Should be able to stake token by accounts[2] ', async () => {

        await this.tokenhold.stake(web3.utils.toHex(500 * 10 ** 18), {from : accounts[2]});

    });

    it('Should be able to transfer token by accounts 1 to accounts 5 ', async () => {

        await this.tokenhold.transfer(accounts[5],web3.utils.toHex(50 * 10 ** 18), {from : accounts[1]});

    });

    it('Should check a balance of a beneficiary accounts[5] after sending tokens', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[1]);
        assert.equal(owner.toString(),'50000000000000000000');

    });

    it('Should check a balance of a beneficiary accounts[5] after sending tokens', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[5]);
        assert.equal(owner.toString(),'46500000000000000000');

    });

    it('Should check a balance of a beneficiary accounts[4] before redeem gain tokens', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[4]);
        assert.equal(owner.toString(),'0');

    });

    it('Should be able to redeemGain token by accounts[4] ', async () => {

        await this.tokenhold.redeemGain({from : accounts[4]});

    });

    it('Should check a balance of a beneficiary accounts[4] after redeem gain tokens', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[4]);
        assert.equal(owner.toString(),'999999999999999999');

    });

    it('Should check a balance of a beneficiary accounts[3] before redeem tokens', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[3]);
        assert.equal(owner.toString(),'0');

    });

    it('Should be able to redeemGain token by accounts[4] ', async () => {

        await this.tokenhold.redeemGain({from : accounts[3]});

    });

    it('Should check a balance of a beneficiary accounts[3] after redeem gain tokens', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[3]);
        assert.equal(owner.toString(),'444444444444444444');

    });

    it('Should check a balance of a beneficiary accounts[2] before redeem tokens', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[2]);
        assert.equal(owner.toString(),'0');

    });

    it('Should be able to redeemGain token by accounts[2] ', async () => {

        await this.tokenhold.redeemGain({from : accounts[2]});

    });

    it('Should check a balance of a beneficiary accounts[3] after redeem gain tokens', async () => {

        let owner = await this.tokenhold.balanceOf.call(accounts[2]);
        assert.equal(owner.toString(),'555555555555555555');

    });

    it('Should be able to transferFrom accounts4 by account 1 ', async () => {

        await this.tokenhold.transferFrom(accounts[4], accounts[1],'50000000000',{from : accounts[1]});

    });

    it('Should be able to  change admin', async () => {

        await this.tokenhold.changeAdmin(accounts[9],{from : accounts[0]});

    });

    it('Should be able to unstake token by accounts[4] ', async () => {

        await this.tokenhold.unStake(web3.utils.toHex(900 * 10 ** 18),{from : accounts[4]});

    });

    it('Should be able to set min stake token by accounts[9] ', async () => {

        await this.tokenhold.setMinStake(web3.utils.toHex(1 * 10 ** 18),{from : accounts[0]});

    });

})

