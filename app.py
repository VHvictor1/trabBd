from flask import Flask, render_template, request, redirect, url_for, session
from flaskext.mysql import MySQL
import os

app = Flask(__name__)
app.secret_key = 'useInfo'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = '#VHvictor2'
app.config['MYSQL_DATABASE_DB'] = 'trabalho_bd'

mysql = MySQL(app)

# ROTA DE LOGIN
@app.route("/", methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM estudante WHERE email = %s AND senha = %s", (email, password))
        user = cursor.fetchall()
        session['user'] = user
        cursor.close()
        conn.close()
        if user:
            return render_template('home.html', user=user)
        else:
            return redirect(url_for('register'))
    return '''
    <form method="post">
        <input type="text" name="email" placeholder="email" required /><br>
        <input type="password" name="password" placeholder="Password" required /><br>
        <button type="submit">Login</button>
    </form>
    <a href="/register">
        <button>Registrar</button>
    </a>
    '''

# ROTA DE HOME 
@app.route("/home", methods=['GET'])
def home():
    user = session['user']
    return render_template('home.html', user=user)

#LOGOUT

@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for('login'))

# ROTA DE ADM 
@app.route("/administracao", methods=['GET'])
def admin():
    user = session['user']
    return render_template('admin.html', user=user)

# CRUD ESTUDANTE

# CREATE ESTUDANTE
@app.route("/register", methods=['POST', 'GET'])
def register():
    if request.method == 'POST':
        name = request.form.get('name')
        password = request.form.get('password')
        email = request.form.get('email')
        number = request.form.get('number')
        course = request.form.get('course')
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO estudante (nome, curso, matricula, email, senha) VALUES (%s, %s, %s, %s, %s);", (name,course, number, email, password))
        user = cursor.fetchone()
        conn.commit()
        if cursor.rowcount > 0:
            return redirect(url_for('login'))
        cursor.close()
        conn.close()

    return '''
    <form method="post">
        <input type="text" name="name" placeholder="nome" required /><br>
        <input type="text" name="course" placeholder="curso" required /><br>
        <input type="text" name="number" placeholder="matrícula" required /><br>
        <input type="text" name="email" placeholder="email" required /><br>
        <input type="text" name="password" placeholder="senha" required /><br>
        <button type="submit">Cadastrar</button>
    </form>
    '''

# READ ESTUDANTES
@app.route('/estudantes', methods=['GET'])
def get_estudantes():
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM estudante')
    resultados = cursor.fetchall()
    conn.commit()
    return render_template('getPageEstudantes.html', resultados=resultados)

# UPDATE ESTUDANTE
@app.route('/perfil', methods=['GET', 'POST'])
def edit_estudantes():
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        user = session['user']
        print(user[0][0])
        cursor.execute('SELECT * FROM estudante WHERE id = %s', (user[0][0],))
        resultado = cursor.fetchone()
        nome = request.form.get('nome')
        curso = request.form.get('curso')
        matricula = request.form.get('matricula')
        cursor.execute('UPDATE estudante SET nome=%s, curso=%s, matricula=%s WHERE id = %s', (nome, curso, matricula, user[0][0],))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for('edit_estudantes'))
    else:
        conn = mysql.connect()
        cursor = conn.cursor()
        user = session['user']
        cursor.execute('SELECT * FROM estudante WHERE id = %s', (user[0][0],))
        resultado = cursor.fetchone()
        conn.commit()
        cursor.close()
        conn.close()
        return '''
        <form method="post" action="/perfil">
            <input type="text" value="{}" name="nome" />
            <input type="text" value="{}" name="curso"/>
            <input type="text" value="{}" name="matricula"/>
            <button type="submit">Alterar</button>
        </form>
        <form action="/logout">
            <button type="submit">sair</button>
        </form>
        <form method="post" action="/delete_estudante/{}">
            <button type="submit">Deletar usuário</button>
        </form>
        '''.format(resultado[1], resultado[2], resultado[3], resultado[0])


# DELETE ESTUDANTES
@app.route('/delete_estudante/<int:id>', methods=['GET', 'POST'])
def delete_estudante(id):
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute('DELETE FROM estudante WHERE id = %s', (id,))
        conn.commit()
        return redirect(url_for('login'))
    else:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute('DELETE FROM estudante WHERE id = %s', (id,))
        conn.commit()
        return redirect(url_for('get_estudantes'))

# CRUD DE DISCIPLINA

#READ DISCIPLINA
@app.route('/classes', methods=['GET'])
def get_classes():
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM disciplina')
    resultados = cursor.fetchall()
    conn.commit()
    return render_template('getPageClass.html', resultados=resultados)

# CRUD DE PROFESSOR

# READ PROFESSOR
@app.route('/teacher', methods=['GET'])
def get_teacher():
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM professor')
    resultados = cursor.fetchall()
    conn.commit()

    return render_template('getPageTeacher.html', resultados=resultados)


# CRUD DE AVALIAÇÃO DO PROFESSOR

# CREATE AVALIAÇAO DO PROFESSOR
@app.route('/comment_teacher/<int:id>', methods=['GET', 'POST'])
def comment_teacher(id):
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        user = session['user']
        value = request.form.get('value')
        comment = request.form.get('comment')
        cursor.execute('INSERT INTO avaliacaoProf(valor, comentario, codProfessorAvaliacao, codEstudanteAvaliacao) VALUES (%s, %s, %s, %s)', (value, comment, id, user[0][0]))
        conn.commit()
        return redirect(url_for('get_teacher'))
    else :
        return '''
        <form method="post">
            <label for="value">valor entre 1 e 5</label>
            <input type="number" id="value" name="value" min="1" max="5" required/>
            <textarea name="comment" placeholder="Deseja adiciona um comentário?"></textarea><br>
            <button type="submit">adicionar</button>
        </form>
        '''
    
# READ DE AVALIAÇÃO DO PROFESSOR
@app.route('/teacher_comments/<int:id>', methods=['GET'])
def get_teacher_comments(id):
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM avaliacaoProf WHERE codProfessorAvaliacao = %s', (id))
    resultados = cursor.fetchall()
    user = session['user']
    conn.commit()
    return render_template('commentTeacher.html', resultados=resultados, user=user)

# UPDATE DE AVALIAÇÃO DO PROFESSOR 
@app.route('/edit_professor_comment/<int:id>', methods=['GET','POST'])
def edit_professor_comment(id):
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        user = session['user']
        cursor.execute('SELECT * FROM avaliacaoProf WHERE id = %s', (id,))
        resultado = cursor.fetchone()
        value = request.form.get('value')
        comment = request.form.get('comment')
        if resultado and resultado[4] == user[0][0]:
            cursor.execute('UPDATE avaliacaoProf SET valor=%s, comentario=%s WHERE id = %s', (value, comment, id))
            conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for('get_teacher_comments', id=resultado[3]))
    else :
        conn = mysql.connect()
        cursor = conn.cursor()
        user = session['user']
        cursor.execute('SELECT * FROM avaliacaoProf WHERE id = %s', (id))
        resultado = cursor.fetchone()
        conn.commit()
        cursor.close()
        conn.close()
        return '''
        <form method="post" action="/edit_professor_comment/{}">
            <label for="value">valor entre 1 e 5</label>
            <input type="number" id="value" name="value" min="1" max="5" value={} required/>
            <textarea name="comment" value={} ></textarea><br>
            <button type="submit">Modificar</button>
        </form>
        '''.format(resultado[0], resultado[1], resultado[2])

# DELETE DE AVALIAÇAO DO PROFESSOR
@app.route('/delete_professor_comment/<int:id>', methods=['POST'])
def delete_professor_comment(id):
    conn = mysql.connect()
    cursor = conn.cursor()
    user = session['user']
    cursor.execute('SELECT * FROM avaliacaoProf WHERE id = %s', (id,))
    resultado = cursor.fetchone()
    print(resultado)
    if resultado and resultado[4] == user[0][0]:
        cursor.execute('DELETE FROM avaliacaoProf WHERE id = %s', (id,))
        conn.commit()
    cursor.close()
    conn.close()
    return redirect(url_for('get_teacher_comments', id=resultado[3]))


# CRUD DE AVALIAÇÃO DISCICPLINA

# CREATE AVALIAÇÃO DISCICPLINA
@app.route('/comment_classes/<int:id>', methods=['GET', 'POST'])
def comment_classes(id):
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        user = session['user']
        value = request.form.get('value')
        comment = request.form.get('comment')
        cursor.execute('INSERT INTO avaliacaoDisciplina(valor, comentario, codDisciplina, codEstudante) VALUES (%s, %s, %s, %s)', (value, comment, id, user[0][0]))
        conn.commit()
        return redirect(url_for('get_classes'))
    else :
        return '''
        <form method="post">
            <label for="value">valor entre 1 e 5</label>
            <input type="number" id="value" name="value" min="1" max="5" required/>
            <textarea name="comment" placeholder="Deseja adiciona um comentário?"></textarea><br>
            <button type="submit">adicionar</button>
        </form>
        '''

# READ AVALIAÇÃO DISCIPLINA 
@app.route('/classes_comments/<int:id>', methods=['GET'])
def get_classes_comments(id):
    conn = mysql.connect()
    cursor = conn.cursor()
    user = session['user']
    cursor.execute('SELECT * FROM avaliacaoDisciplina WHERE codDisciplina = %s', (id))
    resultados = cursor.fetchall()
    conn.commit()
    return render_template('commentClasses.html', resultados=resultados, user=user)

# UPDATE DE AVALIAÇÃO DA DISCIPLINA
@app.route('/edit_classes_comment/<int:id>', methods=['GET','POST'])
def edit_classes_comment(id):
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        user = session['user']
        cursor.execute('SELECT * FROM avaliacaoDisciplina WHERE id = %s', (id,))
        resultado = cursor.fetchone()
        print(resultado)
        value = request.form.get('value')
        comment = request.form.get('comment')
        if resultado and resultado[4] == user[0][0]:
            cursor.execute('UPDATE avaliacaoDisciplina SET valor=%s, comentario=%s WHERE id = %s', (value, comment, id))
            conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for('get_classes_comments', id=resultado[1]))
    else :
        conn = mysql.connect()
        cursor = conn.cursor()
        user = session['user']
        cursor.execute('SELECT * FROM avaliacaoDisciplina WHERE id = %s', (id))
        resultado = cursor.fetchone()
        conn.commit()
        cursor.close()
        conn.close()
        return '''
        <form method="post" action="/edit_classes_comment/{}">
            <label for="value">valor entre 1 e 5</label>
            <input type="number" id="value" name="value" min="1" max="5" value={} required/>
            <textarea name="comment" value={} ></textarea><br>
            <button type="submit">Modificar</button>
        </form>
        '''.format(resultado[0], resultado[2], resultado[3])

# DELETE DE AVALIAÇAO DISCIPLINA
@app.route('/delete_classes_comment/<int:id>', methods=['POST'])
def delete_classes_comment(id):
    conn = mysql.connect()
    cursor = conn.cursor()
    user = session['user']
    cursor.execute('SELECT * FROM avaliacaoDisciplina WHERE id = %s', (id,))
    resultado = cursor.fetchone()
    if resultado and resultado[4] == user[0][0]:
        cursor.execute('DELETE FROM avaliacaoDisciplina WHERE id = %s', (id,))
        conn.commit()
    cursor.close()
    conn.close()
    return redirect(url_for('get_classes_comments', id=resultado[1]))


@app.route('/denuncias', methods=['GET'])
def denuncias():
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM view_denuncia_avaliacao")
    denuncias = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('denuncias.html', denuncias=denuncias)


@app.route('/report_comment/<string:type>/<int:id>', methods=['GET', 'POST'])
def report_comment(type, id):
    if request.method == 'POST':
        conn = mysql.connect()
        cursor = conn.cursor()
        if type == 'professor':
            comment = request.form.get('comment') or ""
            cursor.execute('INSERT INTO denunciaAvaliacaoProf(comentario, codAvaliacaoProf) VALUES (%s, %s)', (comment, id))
            conn.commit()
            cursor.close()
            conn.close()
            return redirect(url_for('get_teacher'))
        elif type == 'classes':
            comment = request.form.get('comment') or ""
            cursor.execute('INSERT INTO denunciaAvaliacaoDisciplina(comentario, codAvaliacaoDisciplina) VALUES (%s, %s)', (comment, id))
            conn.commit()
            cursor.close()
            conn.close()
            return redirect(url_for('get_classes'))
        else:
            return 'Tipo inválido'
    else:
        return '''
            <form method="post" action="/report_comment/{}/{}">
                <textarea name="comment"></textarea><br>
                <button type="submit">Denunciar</button>
            </form>
            '''.format(type, id)


@app.route('/aceitar_denuncia/<int:id>/<string:type>', methods=['POST'])
def aceitar_denuncia(type, id):
    conn = mysql.connect()
    cursor = conn.cursor()
    if type == 'denunciaAvaliacaoDisciplina':
        cursor.execute('DELETE FROM avaliacaoDisciplina WHERE id = %s', (id))
        conn.commit()
        cursor.close()
        conn.close()
    else:
        cursor.execute('DELETE FROM avaliacaoProf WHERE id = %s', (id))
        conn.commit()
        cursor.close()
        conn.close()
    return redirect(url_for('denuncias'))

@app.route('/deletar_denuncia/<int:id>/<string:type>', methods=['POST'])
def deletar_denuncia(type, id):
    conn = mysql.connect()
    cursor = conn.cursor()
    if type == 'denunciaAvaliacaoDisciplina':
        cursor.execute('DELETE FROM denunciaAvaliacaoDisciplina WHERE id = %s', (id))
        conn.commit()
        cursor.close()
        conn.close()
    else:
        cursor.execute('DELETE FROM denunciaAvaliacaoProf WHERE id = %s', (id))
        conn.commit()
        cursor.close()
        conn.close()
    return redirect(url_for('denuncias'))


  
