const { expect } = require("chai");
const { ethers } = require("hardhat");

describe('TodoList', async () => {
  let todo

  beforeEach(async () => {
    const Todo = await ethers.getContractFactory('TodoList')
    todo = await Todo.deploy('My Todo')
    todo.deployed()
  })

  it("Should create and update the name of TodoList", async () => {
    expect(await todo.name()).to.equal('My Todo')

    await todo.updateName("My Todo Dapp")

    expect(await todo.name()).to.equal('My Todo Dapp')
  })

  it("Should create a new Todo", async () => {
    await todo.createTodo("Todo 1")

    const todos = await todo.getAllTodos()
    expect(todos[0].content).to.equal("Todo 1")
  })

  it("Should Update the content of a specific todo", async() => {
    await todo.createTodo("Todo 1")

    await todo.updateTodo(0, "new Todo", true)

    const todos = await todo.getAllTodos()
    expect(todos[0].content).to.equal("new Todo")
    expect(todos[0].isCompleted).to.equal(true)
  })

  it("Should Toggle the isCompleted field", async() => {
    await todo.createTodo('Todo 1')

    await todo.toggleCompletedById(0)
    
    let todos = await todo.getAllTodos()
    expect(todos[0].isCompleted).to.equal(true)

    await todo.toggleCompletedById(0)
    todos = await todo.getAllTodos()
    expect(todos[0].isCompleted).to.equal(false)
  })

  it("Should get a single todo by ID", async () => {
    await todo.createTodo("Todo 1")

    const todoItem = await todo.getTodoById(0)
    
    expect(todoItem.content).to.equal('Todo 1')
    expect(todoItem.isCompleted).to.equal(false)
  })
})