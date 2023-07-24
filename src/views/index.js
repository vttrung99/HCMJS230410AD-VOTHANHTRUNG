import express from 'express';
const router = express.Router();
import fs from 'fs';
import path from 'path';
import axios from 'axios';

router.use('/', (req, res) => {
    fs.readFile(path.join(__dirname, "templates/todos.html"), 'utf-8', async (err, data) => {
        if (err) {
            return res.send("Load ui error")
        }
        let todoContent = ``;
        let todos;
        await axios.get("http://localhost:8000/api/v1/todos")
            .then(res => {
                todos = res.data.data
                // console.log("🚀 ~ file: index.js:18 ~ fs.readFile ~ todos:", todos)
            })
            .catch(err => {
                todos = []
            })

        // console.log(todos)

        const filterTodos = todos.filter(todo => todo.completed == false)
        console.log("abc",filterTodos.length)
        todos.map((todo, index) => {
            const todoTitle = todo.completed
                ? `<del>${todo.title}</del>` // Nếu todo đã hoàn thành (completed là true) thì gạch ngang tiêu đề.
                : todo.title; // Nếu todo chưa hoàn thành (completed là false) thì hiển thị tiêu đề bình thường.
            todoContent += `
            <li class="list-group-item d-flex justify-content-between 
            align-items-center border-start-0 border-top-0 border-end-0 border-bottom rounded-0 mb-2">
                <div class="d-flex align-items-center">
                    ${todo.completed
                    ? `<input class="form-check-input me-2" type="checkbox" value=""
                     checked="false" onChange={handleChange(event,${todo.id})} aria-label="..." />`
                    : `<input class="form-check-input me-2" type="checkbox" value=""  onChange={handleChange(event,${todo.id})} aria-label="..." />`}
                           ${!todo.completed ? `<span>${todo.title} </span>` : `<span style="text-decoration: line-through">${todo.title} </span>`}
                </div>
                <button onclick={deleteTodo(event,${todo.id})} class="btn btn-danger">Delete</button>
            </li>
            `
        });
        const responseObj = {
            filterTodosLength: filterTodos.length,
            todoContent: todoContent,
        };
        // res.send(data.replace("{{task}}", filterTodos.length))
        res.send(data.replace("{{todoContent}}", todoContent));
    })
})
module.exports = router;